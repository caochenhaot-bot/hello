import uuid
from data_analysis import predict
from read_data import read_data,drop_features
from missing_scale import fill_missing_values,scale_data
import sys
import os
# 获取前端发送过来的文件地址
predict_file_path = sys.argv[1]
predict_json_path = sys.argv[2]
#print(type(predict_json_path))
#predict_file_path = r'D:\Software-Cup\OnlinePredict\c238631452434291ab76b045936c8e4e.csv'
#predict_file_path1='http://localhost:9090/python/0f7057866cdc4b36b49d8621e352dfad.csv'
# 读取文件中的数据
data, y = read_data(predict_file_path)

data = drop_features(data)

data = fill_missing_values(data)

data = scale_data(data)

# 定义文件保存的目录路径
output_directory = 'D:\\code\\Software-Cup\\json' 

output_name = '{}.json'.format(predict_json_path)

# 将文件名赋值给变量此变量是在线预测输出的json文件名
output_predict_file_name = os.path.join(output_directory, output_name)

predict(r'D:\code\Software-Cup\python\dnn_model_88.h5', data, output_predict_file_name,predict_file_path)


