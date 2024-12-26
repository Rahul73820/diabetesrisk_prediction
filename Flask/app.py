from flask import Flask, jsonify, request
import random
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


def generate_sample_data():
    genders = ['male', 'female']
    diabetes_risk = ['Yes', 'No']
    samples = []
    
    for _ in range(250):
        sample = {
            "Gender": random.choice(genders),
            "Predicted VF Area (cm²)": round(random.uniform(50, 150), 2),  # Random values for VF Area
            "Pancreas Density (HU)": round(random.uniform(20, 60), 2),  # Random values for Pancreas Density
            "Diabetes Risk": random.choice(diabetes_risk)
        }
        samples.append(sample)
    
    return samples


data = generate_sample_data()

@app.route('/')
def home():
    return jsonify({"message": "Welcome to the Diabetes Risk Prediction API!"})

@app.route('/generate-data', methods=['GET'])
def generate_data_api():
    sample_index = int(request.args.get('index', 0))   
    if 0 <= sample_index < len(data):
        sample = data[sample_index]
        
        
        gender = sample["Gender"]
        vf_area = sample["Predicted VF Area (cm²)"]
        pancreas_density = sample["Pancreas Density (HU)"]
        
        # Set default risk prediction
        diabetes_risk = "Yes"
        
         
        if 30 <= pancreas_density <= 50:
             
            if (gender == "male" and vf_area > 111) or (gender == "female" and vf_area > 96):
                diabetes_risk = "No"
        
         
        sample["Diabetes Risk"] = diabetes_risk
        return jsonify({"sample": sample})
    else:
         
        avg_sample = {
            "Gender": "male",
            "Predicted VF Area (cm²)": 105,
            "Pancreas Density (HU)": 42,   
            "Diabetes Risk": "No"
        }
        return jsonify({"sample": avg_sample})

if __name__ == '__main__':
    app.run(debug=True)
