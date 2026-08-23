---
name: create-video
description: Tạo video bài giảng & animation toán học, thuật toán Machine Learning / Deep Learning bằng thư viện Manim (Gradient Descent, Neural Networks, Linear Regression, Loss Landscape).
---

# Create Video Animation with Manim

Sinh mã nguồn Python Manim và render video bài giảng toán học/AI trực quan.

## Các chủ đề hỗ trợ
- Gradient Descent & Optimization
- Neural Network architecture & Forward/Backpropagation
- Linear & Logistic Regression
- Loss Landscape 3D

## Lệnh Render
```bash
# Preview nhanh (720p 30fps)
manim -qm scene.py SceneName

# Bản xuất bản chất lượng cao (1080p 60fps)
manim -qh scene.py SceneName
```
