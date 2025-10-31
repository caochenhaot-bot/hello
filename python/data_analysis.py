import warnings
import random
import json
import pymysql
import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt
from tensorflow.keras.models import load_model

# =========================
# 1. 数据分析模块
# =========================
def data_analysis(data, y):
    """
    data: 包含特征列和标签列的 DataFrame
    y:    标签列（Series），表示每条样本的高血压类型
          例如：0=正常血压, 1=原发性高血压, 2=继发性高血压
    """

    # 画风格设置
    sns.set(style="darkgrid")
    plt.rcParams['axes.unicode_minus'] = False   # 允许负号正常显示
    plt.rcParams['font.family'] = ['SimHei']     # 中文字体（黑体）

    # 1) 统计不同高血压类型的样本数量分布
    ax = sns.countplot(x=y)
    ax.set_title('高血压类型分布')
    plt.xlabel('高血压类型')
    plt.ylabel('人数')
    plt.show()

    # 2) 随机挑一个特征，画该特征的分布（概率密度曲线）
    warnings.filterwarnings('ignore')

    # 先移除标签列，拿到纯特征
    # 注意：data 里可能已经包含 y 这一列，也可能没有
    # 我们用 y.name 作为列名来安全删除
    data_no_label = data.drop(columns=[y.name], errors='ignore')

    # 特征列表
    features = data_no_label.columns.tolist()

    # 随机抽 1 个特征来看分布（比如收缩压、BMI、血糖等）
    if len(features) > 0:
        plot_features = random.sample(features, k=1)

        for feature in plot_features:
            tmp = data_no_label.reset_index(drop=True)

            sns.kdeplot(tmp[feature], fill=True)
            plt.title(f'{feature} 指标分布')
            plt.xlabel(feature)
            plt.ylabel('概率密度')
            plt.show()

    # （可选）如果你后面还想把标签拼回去：
    # data_full = pd.concat([data_no_label, y], axis=1)

    # ========== 可选热力图，特征相关性 ==========
    """
    corr = data_no_label.corr()
    plt.figure(figsize=(12, 10))
    sns.heatmap(corr, cmap='coolwarm', annot=False)
    plt.title('特征相关性热力图')
    plt.show()
    """


# =========================
# 2. 数据库连接（保持原系统用的MySQL存储结构）
# =========================
conn = pymysql.connect(
    host='127.0.0.1',
    user='root',
    password='123456',
    database='softwarecup',
    charset='utf8'
)
print("数据库连接成功")
cursor = conn.cursor()

# 预测时用到的原始上传文件所在目录（用于生成URL和匹配sys_testfile）
predict_directory = r'D:\code\Software-Cup\Software-Cup\OnlinePredict/'


# =========================
# 3. 高血压类型预测模块（多分类）
# =========================
def predict(model_path, data, output_path, predict_file_path):
    """
    用训练好的模型对输入样本进行高血压类型预测，并把结果：
    1. 写入数据库 sys_result
    2. 另外导出为 JSON 文件

    参数:
    - model_path: 训练好的高血压类型判别模型(.h5等)
                  模型输出应为 softmax 概率，形状 (样本数, 类别数)
    - data: 预处理后的特征矩阵 (DataFrame 或 np.array)，不包含标签列
    - output_path: 预测结果要输出成 JSON 的路径
    - predict_file_path: 这批待测数据的原始 csv 路径
                         用它推导 URL，从而在数据库中追溯是哪次测试
    """

    # 1. 加载模型
    model = load_model(model_path)

    # 2. 执行预测
    #    这里假设模型是多分类，最后一层是 softmax
    #    model.predict(data) -> (N, C)
    y_pred_prob = model.predict(data)
    # 取每条样本概率最高的类别索引
    y_pred = y_pred_prob.argmax(axis=1)

    # （如果你想看概率也可以保留y_pred_prob）

    # 3. 生成访问该上传文件的URL
    #    原系统逻辑是在前端通过URL定位一条测试记录
    url = 'http://localhost:9090/DataTest/' + predict_file_path[len(predict_directory):]
    print("当前批次数据URL:", url)

    # 4. 写入数据库
    #    sys_result 表中：
    #    - testid: 第几条记录
    #    - result: 模型预测的类别编号
    #    - create_time: 入库时间
    #    - testfile_id: 外键，指向 sys_testfile（通过 url 反查）
    #
    #    对我们来说，result 不再表示“故障类型编号”
    #    而是“高血压类型编号”
    #    例如：
    #        0 = 正常血压
    #        1 = 原发性高血压
    #        2 = 继发性高血压
    #
    for i, pred in enumerate(y_pred):
        sql_insert = """
            INSERT INTO sys_result (testid, result, create_time, testfile_id)
            VALUES (
                %s,
                %s,
                NOW(),
                (SELECT id FROM sys_testfile WHERE url=%s)
            )
        """
        params = (i, int(pred), url)
        cursor.execute(sql_insert, params)

    # 提交事务
    conn.commit()

    # 5. 导出预测结果为 JSON （给前端或接口调取）
    #    result 这个 dict: { "0": 2, "1": 1, ... }
    #    key   -> 第几条样本
    #    value -> 预测到的高血压类型编号
    result_json_obj = {}
    for i, pred in enumerate(y_pred):
        result_json_obj[str(i)] = int(pred)

    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(result_json_obj, f, ensure_ascii=False)

    print("预测完成，结果已写入数据库并导出到：", output_path)
    return output_path


# =========================
# 4. （可选）类别编号到中文解释
# =========================
# 你可以在别的模块/前端用这个映射，把数字翻成人话：
hypertension_label_map = {
    0: "正常血压",
    1: "原发性高血压",
    2: "继发性高血压"
}
# 前端拿到 result_json_obj 里的数字后，用这个字典显示中文即可
