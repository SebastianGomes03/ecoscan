from PIL import Image
def predict_image(img_path, model, class_names):
    """
    Predice la clase de una imagen usando el modelo entrenado.
    img_path: ruta a la imagen
    model: modelo keras cargado
    class_names: lista de nombres de clases
    """
    img = Image.open(img_path).convert('RGB')
    img = img.resize((224, 224))
    x = np.array(img)
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)
    preds = model.predict(x)
    idx = np.argmax(preds[0])
    return class_names[idx], float(preds[0][idx])
import os
import tensorflow as tf
# GPU setup for RTX 4050
gpus = tf.config.list_physical_devices('GPU')
if gpus:
    try:
        for gpu in gpus:
            tf.config.experimental.set_memory_growth(gpu, True)
        print(f"GPUs available: {[gpu.name for gpu in gpus]}")
    except RuntimeError as e:
        print(e)
else:
    print("No GPU found, running on CPU.")

from tensorflow.keras import layers, models, optimizers, callbacks
from tensorflow.keras.applications import MobileNetV3Large
from tensorflow.keras.applications.mobilenet_v3 import preprocess_input
from sklearn.model_selection import ParameterGrid
import numpy as np

# Paths
# Use both Fauna and Flora for all species classification
import shutil

def create_flat_symlinked_dataset(src_root, flat_root):
    """
    For each species folder (deep) in src_root, create a real copy in flat_root with the species name,
    copying all image files. If the flat_root already exists, skip creation.
    """
    if os.path.exists(flat_root):
        print(f"Flat dataset already exists at {flat_root}, skipping creation.")
        return
    os.makedirs(flat_root, exist_ok=True)
    for dirpath, dirnames, filenames in os.walk(src_root):
        if any(f.lower().endswith((".jpg", ".jpeg", ".png")) for f in filenames):
            species_name = os.path.relpath(dirpath, src_root).replace(os.sep, "__")
            dest_dir = os.path.join(flat_root, species_name)
            os.makedirs(dest_dir, exist_ok=True)
            for f in filenames:
                if f.lower().endswith((".jpg", ".jpeg", ".png")):
                    src_file = os.path.join(dirpath, f)
                    dest_file = os.path.join(dest_dir, f)
                    if not os.path.exists(dest_file):
                        shutil.copy2(src_file, dest_file)
    print(f"Flat dataset created at {flat_root}")



# Permitir elegir entre fauna o flora
import sys



# --- CREAR Y USAR DATASET FLAT DE DatasetChetadoAumented ---
SRC_ROOT = os.path.abspath("DatasetChetadoAumented")
FLAT_ROOT = os.path.abspath("DatasetChetadoAumented_flat")

def create_flat_dataset(src_root, flat_root):
    if os.path.exists(flat_root):
        print(f"Flat dataset already exists at {flat_root}, skipping creation.")
        return
    os.makedirs(flat_root, exist_ok=True)
    for dirpath, dirnames, filenames in os.walk(src_root):
        if any(f.lower().endswith((".jpg", ".jpeg", ".png")) for f in filenames):
            species_name = os.path.relpath(dirpath, src_root).replace(os.sep, "__")
            dest_dir = os.path.join(flat_root, species_name)
            os.makedirs(dest_dir, exist_ok=True)
            for f in filenames:
                if f.lower().endswith((".jpg", ".jpeg", ".png")):
                    src_file = os.path.join(dirpath, f)
                    dest_file = os.path.join(dest_dir, f)
                    if not os.path.exists(dest_file):
                        shutil.copy2(src_file, dest_file)
    print(f"Flat dataset created at {flat_root}")

create_flat_dataset(SRC_ROOT, FLAT_ROOT)
DATASET_DIR = FLAT_ROOT
MODEL_OUT = os.path.abspath("best_combined_classifier_tf.h5")





# Hiperparámetros ajustados para dataset combinado y grande
BATCH_SIZE = 32  # Mayor batch size para aprovechar GPU y dataset grande
LR = 2e-4        # Learning rate un poco mayor para convergencia más rápida
OPTIMIZER = 'adam'  # Adam robusto
DROPOUT = 0.20   # Dropout un poco mayor para evitar overfitting
PATIENCE = 7     # Early stopping más tolerante


IMG_SIZE = (224, 224)
SEED = 42

def get_data_loaders(batch_size):
    # Use only AugmentedDataset_flat for all splits
    full_ds = tf.keras.utils.image_dataset_from_directory(
        DATASET_DIR,
        labels='inferred',
        label_mode='categorical',
        batch_size=batch_size,
        image_size=IMG_SIZE,
        shuffle=True,
        seed=SEED,
    )
    class_names = full_ds.class_names
    print(f"Found {len(class_names)} species classes.")
    # Calculate split sizes
    total_batches = full_ds.cardinality().numpy()
    val_batches = total_batches // 5  # 20% validation
    test_batches = total_batches // 5  # 20% test
    train_batches = total_batches - val_batches - test_batches
    train_ds = full_ds.take(train_batches)
    val_ds = full_ds.skip(train_batches).take(val_batches)
    test_ds = full_ds.skip(train_batches + val_batches)
    # Preprocessing con MobileNetV2
    preprocess = lambda ds: ds.map(lambda x, y: (preprocess_input(x), y), num_parallel_calls=tf.data.AUTOTUNE)
    train_ds = preprocess(train_ds).prefetch(tf.data.AUTOTUNE)
    val_ds = preprocess(val_ds).prefetch(tf.data.AUTOTUNE)
    test_ds = preprocess(test_ds).prefetch(tf.data.AUTOTUNE)
    return train_ds, val_ds, test_ds, len(class_names), class_names

def build_model(num_classes, lr, optimizer_name, dropout_rate):
    base_model = MobileNetV3Large(weights='imagenet', include_top=False, input_shape=(224,224,3))
    base_model.trainable = False
    inputs = layers.Input(shape=(224,224,3))
    x = base_model(inputs, training=False)
    x = layers.GlobalAveragePooling2D()(x)
    if dropout_rate > 0.0:
        x = layers.Dropout(dropout_rate)(x)
    outputs = layers.Dense(num_classes, activation='softmax')(x)
    model = models.Model(inputs, outputs)
    if optimizer_name == 'adam':
        opt = optimizers.Adam(learning_rate=lr)
    elif optimizer_name == 'sgd':
        opt = optimizers.SGD(learning_rate=lr, momentum=0.9)
    else:
        opt = optimizers.RMSprop(learning_rate=lr)
    model.compile(optimizer=opt, loss='categorical_crossentropy', metrics=['accuracy'])

    # Fine-tuning: descongelar últimas 40 capas después de 3 épocas
    def unfreeze_callback():
        class UnfreezeLastLayers(callbacks.Callback):
            def on_epoch_begin(self, epoch, logs=None):
                if epoch == 3:
                    for layer in base_model.layers[-40:]:
                        layer.trainable = True
                    print("Descongeladas las últimas 40 capas de MobileNetV3Large para fine-tuning.")
        return UnfreezeLastLayers()
    model.unfreeze_callback = unfreeze_callback
    return model

import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
from sklearn.manifold import TSNE

def plot_training_curves(history, outdir="metrics"):
    os.makedirs(outdir, exist_ok=True)
    plt.figure(figsize=(8,4))
    plt.plot(history.history['loss'], label='Train Loss')
    plt.plot(history.history['val_loss'], label='Val Loss')
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.legend()
    plt.title('Loss per Epoch')
    plt.savefig(os.path.join(outdir, "loss_curve.png"))
    plt.close()

    plt.figure(figsize=(8,4))
    plt.plot(history.history['accuracy'], label='Train Acc')
    plt.plot(history.history['val_accuracy'], label='Val Acc')
    plt.xlabel('Epoch')
    plt.ylabel('Accuracy')
    plt.legend()
    plt.title('Accuracy per Epoch')
    plt.savefig(os.path.join(outdir, "accuracy_curve.png"))
    plt.close()

def plot_confusion_matrix(model, class_names, curated_dir, outdir="metrics"):
    os.makedirs(outdir, exist_ok=True)
    curated_ds = tf.keras.utils.image_dataset_from_directory(
        curated_dir,
        labels='inferred',
        label_mode='categorical',
        batch_size=32,
        image_size=(224,224),
        shuffle=False
    )
    y_true = []
    y_pred = []
    for batch_x, batch_y in curated_ds:
        preds = model.predict(preprocess_input(batch_x))
        y_true.extend(np.argmax(batch_y, axis=1))
        y_pred.extend(np.argmax(preds, axis=1))
    cm = confusion_matrix(y_true, y_pred)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=class_names)
    fig, ax = plt.subplots(figsize=(10,10))
    disp.plot(ax=ax, xticks_rotation=90)
    plt.title("Confusion Matrix")
    plt.savefig(os.path.join(outdir, "confusion_matrix.png"))
    plt.close()

def plot_tsne_embeddings(model, curated_dir, class_names, outdir="metrics"):
    os.makedirs(outdir, exist_ok=True)
    feature_model = tf.keras.Model(model.input, model.layers[-2].output)
    curated_ds = tf.keras.utils.image_dataset_from_directory(
        curated_dir,
        labels='inferred',
        label_mode='categorical',
        batch_size=32,
        image_size=(224,224),
        shuffle=False
    )
    features = []
    labels = []
    for batch_x, batch_y in curated_ds:
        feats = feature_model.predict(preprocess_input(batch_x))
        features.append(feats)
        labels.append(np.argmax(batch_y, axis=1))
    features = np.concatenate(features)
    labels = np.concatenate(labels)
    tsne = TSNE(n_components=2, random_state=42)
    emb = tsne.fit_transform(features)
    plt.figure(figsize=(8,8))
    for i, cname in enumerate(class_names):
        idx = labels == i
        plt.scatter(emb[idx,0], emb[idx,1], label=cname, alpha=0.6, s=10)
    plt.legend(markerscale=2, bbox_to_anchor=(1.05, 1), loc='upper left')
    plt.title("t-SNE Embeddings (Curated Dataset)")
    plt.tight_layout()
    plt.savefig(os.path.join(outdir, "tsne_embeddings.png"))
    plt.close()

def main():
    print(f"Num GPUs Available: {len(tf.config.list_physical_devices('GPU'))}")
    print(f"Entrenando modelo combinado de FLORA y FAUNA")
    train_ds, val_ds, test_ds, num_classes, class_names = get_data_loaders(BATCH_SIZE)
    model = build_model(num_classes, LR, OPTIMIZER, DROPOUT)
    cb = [
        callbacks.EarlyStopping(patience=PATIENCE, restore_best_weights=True),
        callbacks.ReduceLROnPlateau(monitor='val_loss', factor=0.5, patience=2, min_lr=1e-7, verbose=1),
        model.unfreeze_callback()  # Fine-tuning callback
    ]
    history = model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=100,
        verbose=1,  # Show loading bar
        callbacks=cb
    )
    val_acc = max(history.history['val_accuracy'])
    print("Evaluating on test set...")
    test_loss, test_acc = model.evaluate(test_ds, verbose=1)  # Show loading bar
    print(f"Test Loss: {test_loss:.4f} | Test Accuracy: {test_acc:.4f}")
    # Save model
    model.save(MODEL_OUT)
    print(f"Model saved to {MODEL_OUT}")

    # === MÉTRICAS Y GRÁFICAS ===
    METRICS_DIR = "metrics"
    CURATED_DIR = os.path.abspath("curatedDataset")
    plot_training_curves(history, outdir=METRICS_DIR)
    plot_confusion_matrix(model, class_names, CURATED_DIR, outdir=METRICS_DIR)
    plot_tsne_embeddings(model, CURATED_DIR, class_names, outdir=METRICS_DIR)
    print(f"Métricas y gráficas guardadas en {METRICS_DIR}")

if __name__ == "__main__":
    main()
    # Ejemplo de uso de la función de predicción:
    # model = tf.keras.models.load_model(MODEL_OUT)
    # class_names = ... # cargar la lista de clases usada en entrenamiento
    # img_path = "ruta/a/tu/imagen.jpg"
    # pred, score = predict_image(img_path, model, class_names)
    # print(f"Predicción: {pred} (score={score:.3f})")
