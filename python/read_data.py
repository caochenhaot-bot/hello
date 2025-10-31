import pandas as pd

# ===============================
# 读取高血压数据集
# ===============================
def read_data(train_file_path, val_file_path=None):
    """
    读取训练集或预测输入数据，适用于高血压类型分析系统。

    预期字段：
    - patient_id: 患者编号（仅用于追踪，不参与模型输入）
    - SBP: 收缩压 (mmHg)
    - DBP: 舒张压 (mmHg)
    - HR: 心率 (bpm)
    - Age: 年龄 (岁)
    - BMI: 体重指数
    - Glucose: 空腹血糖
    - Chol: 总胆固醇
    - HyperType: 高血压类型标签（0=正常,1=原发性,2=继发性）
                 预测阶段可能没有这一列
    """

    # 读训练/预测文件
    try:
        df_train = pd.read_csv(train_file_path, index_col="patient_id")
    except Exception:
        df_train = pd.read_csv(train_file_path)

    # 标签列（训练时用，在线预测时通常不存在）
    y_train = df_train['HyperType'].copy() if 'HyperType' in df_train.columns else None

    # 如果给了验证集路径，就继续读验证集
    if val_file_path:
        try:
            df_val = pd.read_csv(val_file_path, index_col="patient_id")
        except Exception:
            df_val = pd.read_csv(val_file_path)

        y_val = df_val['HyperType'].copy() if 'HyperType' in df_val.columns else None

        return df_train, y_train, df_val, y_val

    # 只读一份的情况（训练/预测都支持）
    return df_train, y_train


# ===============================
# 删除重复样本
# ===============================
def remove_duplicates(data, y):
    """
    删除重复样本，保持标签同步
    """
    data = data.drop_duplicates()
    if y is not None:
        y = y.loc[data.index]
    return data, y


# ===============================
# 特征选择 / 丢掉无关列
# ===============================
def drop_features(data):
    """
    保证输入特征与训练时完全一致：
    我们的模型是用下面7个特征训练的：
    ['SBP', 'DBP', 'HR', 'Age', 'BMI', 'Glucose', 'Chol']

    - patient_id 只是病人编号 -> 不参与模型
    - HyperType 是标签 -> 预测阶段不能当输入
    """
    keep_features = ['SBP', 'DBP', 'HR', 'Age', 'BMI', 'Glucose', 'Chol']
    # 只保留模型需要的列，其他都丢掉
    data = data[[col for col in keep_features if col in data.columns]]
    return data
