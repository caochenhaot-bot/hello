import numpy as np
import datetime
import seaborn as sns
import matplotlib.pyplot as plt
from keras.regularizers import l1, l2
from sklearn.metrics import classification_report, confusion_matrix
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from keras.utils import to_categorical
from sklearn.model_selection import train_test_split
from sklearn.utils import compute_class_weight


def train_model(
    X_train,
    y_train,
    X_val=None,
    y_val=None,
    num_classes=3,
    epochs=100,
    batch_size=64
):
    """
    训练高血压类型判别模型（多分类）

    参数说明：
    - X_train: 训练特征 (DataFrame 或 np.array)，例如 [SBP, DBP, HR, Age, BMI, ...]
    - y_train: 训练标签 (Series 或 np.array)，高血压类型编号
        0 = 正常血压
        1 = 原发性高血压
        2 = 继发性高血压
        (如果你有更多类型，可以把 num_classes 改大)

    - X_val, y_val: 验证集（可选）。如果不传，会自动从训练集中按 8:2 划分
    - num_classes: 分类类别数量（默认 3 类）
    - epochs, batch_size: 训练超参数

    返回：
    - model_name: 训练后保存的模型文件名(.h5)，后续预测会直接用这个模型
    """

    # 如果没有单独给验证集，就自己切一部分做验证
    if X_val is None or y_val is None:
        X_train, X_val, y_train, y_val = train_test_split(
            X_train,
            y_train,
            test_size=0.2,
            stratify=y_train,   # 保证各类比例一致
            random_state=42
        )

    # 计算类别权重，处理类别不平衡问题
    # 比如“继发性高血压”样本可能很少，给它更高的权重
    class_weights_array = compute_class_weight(
        class_weight='balanced',
        classes=np.unique(y_train),
        y=y_train
    )
    class_weights = dict(enumerate(class_weights_array))

    # 构建全连接神经网络
    # 结构保持你的风格，只是最后一层不再写死为6，而是 num_classes
    model = Sequential()
    model.add(Dense(94,
                    activation='tanh',
                    input_shape=(X_train.shape[1],),
                    kernel_regularizer=l1(0.01)))
    model.add(Dense(282,
                    activation='tanh',
                    kernel_regularizer=l2(0.01)))
    model.add(Dense(252,
                    activation='tanh',
                    kernel_regularizer=l2(0.01)))
    model.add(Dense(42,
                    activation='tanh',
                    kernel_regularizer=l2(0.01)))
    model.add(Dense(num_classes, activation='softmax'))

    # 编译模型
    # 使用多分类交叉熵
    model.compile(
        loss='categorical_crossentropy',
        optimizer='Adamax',
        metrics=['accuracy']
    )

    # 把标签数据转成 one-hot
    # y_train: [0,1,2,...] -> [[1,0,0],[0,1,0],...]
    y_train_cat = to_categorical(y_train, num_classes=num_classes)
    y_val_cat = to_categorical(y_val, num_classes=num_classes)

    # 训练模型
    history = model.fit(
        X_train,
        y_train_cat,
        epochs=epochs,
        batch_size=batch_size,
        class_weight=class_weights,
        validation_data=(X_val, y_val_cat)
    )

    # ============ 可视化训练情况 ============
    # 损失曲线
    plt.figure()
    plt.plot(history.history['loss'])
    plt.plot(history.history['val_loss'])
    plt.title('模型损失 (训练 vs 验证)')
    plt.ylabel('Loss')
    plt.xlabel('Epoch')
    plt.legend(['训练集', '验证集'], loc='upper right')
    plt.show()

    # 准确率曲线
    plt.figure()
    plt.plot(history.history['accuracy'])
    plt.plot(history.history['val_accuracy'])
    plt.title('模型准确率 (训练 vs 验证)')
    plt.ylabel('Accuracy')
    plt.xlabel('Epoch')
    plt.legend(['训练集', '验证集'], loc='lower right')
    plt.show()

    # ============ 在验证集上评估模型 ============
    y_pred_prob = model.predict(X_val)
    y_pred = y_pred_prob.argmax(axis=1)  # 预测的高血压类型编号
    y_true = y_val  # 注意：这里 y_val 还是原始整数标签

    print("分类报告（高血压类型判别）:")
    print(classification_report(y_true, y_pred))

    # 混淆矩阵
    plt.figure()
    cm = confusion_matrix(y_true, y_pred)
    sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
    plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.title('高血压类型混淆矩阵')
    plt.xlabel('预测类型')
    plt.ylabel('真实类型')
    plt.show()

    # ============ 保存模型 ============
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    model_name = f"hypertension_model_{timestamp}.h5"
    model.save(model_name)

    print("模型已保存为:", model_name)
    return model_name
