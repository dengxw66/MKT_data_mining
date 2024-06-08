from flask import Flask, request, jsonify
import pandas as pd

app = Flask(__name__)

# 读取Excel表格
df = pd.read_excel('D:/Python/SCGC/qualtrics/credamo/222.xlsx')  # 确保Excel文件在同一目录下

@app.route('/getTopic', methods=['POST'])
def get_topic():
    email = request.json.get('email')
    print(email)
    print(f"Received email: {email}")
    user_data = df[df['Email'] == email]
    if not user_data.empty:
        topic = user_data.iloc[0]['Topic']
        print(f"Found topic: {topic}")
        return jsonify({'topic': topic})
    else:
        print("Email not found")
        return jsonify({'error': 'Email not found'}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

# 测试语句-命令行：>curl -X POST http://10.81.20.217:5000/getTopic -H "Content-Type: application/json" -d "{\"email\": \"898599774@qq.com\"}"