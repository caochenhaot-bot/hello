import uuid
import sys
import os

from data_analysis import predict  # 负责模型推理+写入数据库+导出JSON
from read_data import read_data, drop_features
from missing_scale import fill_missing_values, scale_data

# 使用方式（外部调用时传入）：
#   python predict_online.py <待预测csv路径> <输出json文件名不带后缀>
#
# 例如：
#   python predict_online.py D:\...\OnlinePredict\case123.csv result_case123
#
# 解释：
#   1) 待预测csv路径：前端或上传模块生成的、包含患者指标的数据
#   2) 输出json文件名：我们会在本地json目录下生成同名.json，前端就能取这个结果

# 接收命令行参数：前端传进来的数据文件路径 & 输出JSON名
predict_file_path = sys.argv[1]      # 待判定的患者数据（csv）
predict_json_basename = sys.argv[2]  # 输出的json文件名（不含扩展名）

# 读取原始待预测数据
# read_data 返回 (df, y)，但在线预测通常没有真实标签列 HyperType，所以 y 可能是 None
data, _ = read_data(predict_file_path)

# 数据清洗：去掉无关列（姓名/时间戳之类的）
data = drop_features(data)

# 缺失值填补（根据样本量决定0填充/均值/KNN）
data = fill_missing_values(data)

# 标准化（和训练时保持一致）
data = scale_data(data)

# 定义在线预测结果要保存到的目录
output_directory = r'D:\code\Software-Cup\Software-Cup\json'
os.makedirs(output_directory, exist_ok=True)

# 输出的 json 文件全路径
output_predict_file_name = os.path.join(
    output_directory,
    f"{predict_json_basename}.json"
)

# 高血压类型分类模型的路径（这必须是你最新训练并保存的模型）
# 例如：train_model() 返回的文件 hypertension_model_20251029_153812.h5
# 你可以手动指定一个“最新模型”的软链接/副本，例如 hypertension_model_latest.h5
MODEL_PATH = r'D:\code\Software-Cup\Software-Cup\hypertension_model_20251029_112241.h5'

# 调用核心推理逻辑：
#   - 用模型对 data 做高血压类型判定（多分类 softmax → argmax）
#   - 把每一条样本的预测类型写进 MySQL 的 sys_result
#   - 生成一个JSON文件保存预测结果（方便前端直接展示）
predict(
    MODEL_PATH,
    data,
    output_predict_file_name,
    predict_file_path
)

print("在线预测完成。结果JSON：", output_predict_file_name)
