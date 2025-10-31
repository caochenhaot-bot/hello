import pandas as pd
from read_data import remove_duplicates
from missing_scale import fill_missing_values, scale_data
from model import train_model

# 1. 读取我们刚才准备的高血压示例数据
csv_path = r"D:\code\Software-Cup\Software-Cup\python\data\hypertension_dataset.csv"
df = pd.read_csv(csv_path)

# 2. 特征列 & 标签列
# 注意：这些字段名必须和 hypertension_dataset.csv 里的一致
feature_cols = ['SBP','DBP','HR','Age','BMI','Glucose','Chol']
label_col = 'HyperType'

X = df[feature_cols].copy()
y = df[label_col].copy()

# 3. 去重（如果有重复病人记录）
X, y = remove_duplicates(X, y)

# 4. 缺失值填补
X = fill_missing_values(X)

# 5. 标准化
X = scale_data(X)

# 6. 训练模型（num_classes=3 对应：正常/原发性/继发性）
saved_model_path = train_model(
    X_train=X,
    y_train=y,
    X_val=X,          # 用同一批数据当验证集，解决样本太少的问题
    y_val=y,
    num_classes=3,
    epochs=50,
    batch_size=4
)


print("模型已训练并保存为：", saved_model_path)
print("请把这个模型路径填到 predict_online.py 里的 MODEL_PATH 变量里。")
