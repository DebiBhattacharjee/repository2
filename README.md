# PROJECT :
  **Credit Card Fraud Detection**

![](fraud.jpg)

# What is Fraud :
 
  Credit card fraud is an inclusive term for fraud committed using a payment card, such as a credit card or debit card. The purpose may be to obtain goods or services or to make payment to another account, which is controlled by a criminal.
    A typical organization loses approx 5% of its annual revenue due to financial fraud. An RTI query revealed that a total of 2480 cases of frauds 
 involving a large amount of Rs. 32000 crores in 18 public sector banks in India in the first quarter. 

# How to use Machine Learning for fraud detection ?

  In online fraud detection and prevention, machine learning is a collection of artificial intelligence (AI) algorithms trained with our historical data to suggest risk rules. We can then implement the rules to block or allow certain user actions, such as suspicious logins, identity theft, or fraudulent transactions.

# Challenges faced by fraud detection model :

**1. Changing fraud patterns over time** — This one is the toughest to address since the fraudsters are always in the lookout to find new and innovative ways to get around the systems to commit the act. Thus it becomes all-important for the deep learning models to be updated with the evolved patterns to detect. This results in a decrease in the model’s performance and efficiency. Thus the machine learning models need to keep updating or fail their objectives.

**2. Class Imbalance** — Practically only a small percentage of customers have fraudulent intentions. Consequently, there’s an imbalance in the classification of fraud detection models (that usually classify transactions as either fraudulent or non-fraudulent) which makes it harder to build them. The fallout of this challenge is a poor user experience for genuine customers, since catching the fraudsters usually involves declining some legitimate transactions.

**3. Model Interpretations** — This limitation is associated with the concept of explainability since models typically give a score indicating whether a transaction is likely to be fraudulent or not — without explaining why.

**4. Feature generation can be time-consuming** — Subject matter experts can require long periods of time to generate a comprehensive feature set which slows down the fraud detection process.


## Sampling Methods to solve this Unbalanced Data problem

**Random Over-Sampling (ROS)** -
In this technique we over sample the minority class which is our fraud cases, so we copy the cases that are already present in are fradulent cases, so me copy the same cases multiple times till we reach the threshold value that we want in our dataset. The problem with this technique is that it is done by creating the duplicating lots fraud cases that are already present in our dataset that means we will be training our model with lots of duplicate values which won't explain the varriance in the dataset.

**Random Under-Sampling (RUS)** -
In this technique we under sample the majority class which is our legitimate cases, so we remove some of the cases from our dataset which are from legitimate transactions so we remove some of the cases till we have almost the same distribution as of fraud cases. The problem with this technique is that we will endup with throwing lot of useful data and informations which is not prefered in general. 

**Both** -
We can perform both ROS and RUS by increasing the fraud cases and decreasing the legitimate cases.

**Synthetic Minority Over-Sampling (SMOTE)** -
In this technique we over-sample the minority class (i.e fraud) by creating synthetic fraud cases.

## Decision Tree for fraud detection:

The aim of the Decision Tree model is to build a small decision tree with high precision. Based on credit card fraud detection, the decision tree has two stages. The initial step is to build a decision tree using the training data provided, and the later step is to use decision rules to classify incoming transactions.

# Technology Used:
R programming language 

# Installing Required Libraries :

```
install.packages("dplyr")
install.packages("ggplot2")
install.packages("smotefamily")
install.packages("caTools")
install.packages("ROSE")
install.packages("rpart")
install.packages("rpart.plot")
install.packages("caret")
```
# Dataset : 
 (https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud)

