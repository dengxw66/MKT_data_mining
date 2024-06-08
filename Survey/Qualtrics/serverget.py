import logging
import pandas as pd
from flask import Flask, request, jsonify
import os

app = Flask(__name__)

# Set the logging level to DEBUG
app.logger.setLevel(logging.DEBUG)

# Create an empty DataFrame to store fill-in-the-blank answers
fill_in_answers = pd.DataFrame(columns=['Timestamp', 'Answer'])

# Create an empty DataFrame to store multiple-choice answers
choice_answers = pd.DataFrame(columns=['Timestamp', 'Option'])

@app.route('/feedback', methods=['POST'])
def generate_feedback():
    # Get data from Qualtrics
    answer_type = request.form.get('answer_type', '')
    app.logger.debug('answer_type: %s', str(answer_type))
    if answer_type == 'fill_in':
        # If it's a fill-in-the-blank answer
        answer = request.form.get('answer', '')
        app.logger.debug('answer: %s', str(answer))
        add_fill_in_answer_to_dataframe(answer)
    elif answer_type == 'choice':
        # If it's a multiple-choice answer
        option = request.form.get('option', '')
        app.logger.debug('option: %s', str(option))
        add_choice_answer_to_dataframe(option)
    
    # Send response to the frontend
    return jsonify({'message': 'User answer recorded successfully'})

def add_fill_in_answer_to_dataframe(answer):
    global fill_in_answers
    
    # Get current timestamp
    current_timestamp = pd.Timestamp.now()
    
    # Add fill-in-the-blank answer and timestamp to DataFrame
    fill_in_answers = fill_in_answers.append({'Timestamp': current_timestamp, 'Answer': answer}, ignore_index=True)

    # Check and create directory to save Excel file
    save_dir = 'D:/Python/SCGC/qualtrics'
    if not os.path.exists(save_dir):
        os.makedirs(save_dir)
    
    # Save DataFrame to Excel file
    file_path = os.path.join(save_dir, 'fill_in_answers.xlsx')
    fill_in_answers.to_excel(file_path, index=False)

def add_choice_answer_to_dataframe(option):
    global choice_answers
    
    # Get current timestamp
    current_timestamp = pd.Timestamp.now()
    
    # Add multiple-choice option and timestamp to DataFrame
    choice_answers = choice_answers.append({'Timestamp': current_timestamp, 'Option': option}, ignore_index=True)

    # Check and create directory to save Excel file
    save_dir = 'D:/Python/SCGC/qualtrics'
    if not os.path.exists(save_dir):
        os.makedirs(save_dir)
    
    # Save DataFrame to Excel file
    file_path = os.path.join(save_dir, 'choice_answers.xlsx')
    choice_answers.to_excel(file_path, index=False)

if __name__ == '__main__':
    app.run(debug=True)
