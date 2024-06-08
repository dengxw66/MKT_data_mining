from flask import Flask, request, jsonify
import pandas as pd

app = Flask(__name__)

# 读取Excel表格
df = pd.read_excel('D:/Python/SCGC/qualtrics/credamo/test.xlsx')  # 确保Excel文件在同一目录下

@app.route('/getTopic', methods=['GET'])
def get_topic():
    email = request.args.get('email')
    user_data = df[df['Email'] == email]
    if not user_data.empty:
        topic = user_data.iloc[0]['Topic']
        return jsonify({'topic': topic})
    else:
        return jsonify({'error': 'Email not found'}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
    
    # curl -X GET "http://10.81.20.217:5000/getTopic?email=898599774@qq.com"

