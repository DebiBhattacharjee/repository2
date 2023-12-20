# CREDIT CARD FRAUD DETECTION
#===============================================================================================================================

#installing required libraries

install.packages("dplyr")
install.packages("ggplot2")
install.packages("smotefamily")
install.packages("caTools")
install.packages("ROSE")
installed.packages("rpart")
install.packages("rpart.plot")
install.packages("caret")

#Importing required libraries

library(dplyr)
library(ggplot2)
library(smotefamily)
library(caTools)
library(ROSE)
library(rpart)
library(rpart.plot)
library(caret)


# Importing the dataset

credit_card<-read.csv("C:\\Users\\HP\\Desktop\\creditcard.csv")

# View the dataset
View(credit_card)

# Structure of the dataset
str(credit_card)

# The dataset has 2,84,807 rows and 31 columns

# We are converting categorical variable into factor variable in order to ease of our calculations
credit_card$Class<-factor(credit_card$Class,levels = c(0,1))

#get the summary of the data
summary(credit_card)

#number of missing values
sum(is.na(credit_card))
#The dataset has 0 missing values

#===============================================================================================================================


#get the distributions of fraudulent and legitimate transactions

table(credit_card$Class)

#get the percentage of fraudulent and legitimate transactions

prop.table(table(credit_card$Class))

#===============================================================================================================================
#pie chart

labels<-c("legit","fraud")
labels<-paste(labels,round(100*prop.table(table(credit_card$Class)),2))
labels<-paste0(labels,"%")

pie(table(credit_card$Class),labels,col = c("red","blue"),main = "Pie chart of credit card transactions")

#===============================================================================================================================


#No model predictions

predictions<-rep.int(0,nrow(credit_card))
predictions<-factor(predictions,levels = c(0,1))

confusionMatrix(data=predictions,reference = credit_card$Class)

#===============================================================================================================================


#To get small fraction(10%) of our whole dataset that is credit_card in order to ease of our calculations

set.seed(1)
credit_card<-credit_card %>% sample_frac(0.1)
table(credit_card$Class)


ggplot(data = credit_card,aes(x=V1,y=V2,col=Class))+
  geom_point()+
  theme_bw()+
  scale_color_manual(values = c('blue','red'))

#===============================================================================================================================


#split the dataset into train and test data for fraud detection model
set.seed(123)
data_sample=sample.split(credit_card$Class,SplitRatio = 0.80)
train_data<-subset(credit_card,data_sample==TRUE)  
test_data<-subset(credit_card,data_sample==FALSE) 
dim(train_data)
dim(test_data)

#===============================================================================================================================



#Random Over-Sampling(ROS)


table(train_data$Class)
n_legit<-22750
new_frac_legit<-0.50
new_n_total<-n_legit/new_frac_legit



oversampling_result<-ovun.sample(Class~.,
                                 data=train_data,
                                 method="over",
                                 N=new_n_total,
                                 seed=2023)

oversampled_credit<-oversampling_result$data
table(oversampled_credit$Class)


ggplot(data = oversampled_credit,aes(x=V1,y=V2,col=Class))+
  geom_point(position = position_jitter(width = 0.2))+
  theme_bw()+
  scale_color_manual(values = c('blue','red'))

#===============================================================================================================================


#Random Under-Sampling(RUS)

table(train_data$Class) 

n_fraud<-35
new_frac_fraud<-0.50
new_n_total<-n_fraud/new_frac_fraud

undersampling_result<-ovun.sample(Class~.,
                                  data=train_data,
                                  method = "under",
                                  N=new_n_total,
                                  seed=2023)
undersampled_credit<-undersampling_result$data
table(undersampled_credit$Class)


ggplot(data = undersampled_credit,aes(x=V1,y=V2,col=Class))+
  geom_point(position = position_jitter(width = 0.2))+
  theme_bw()+
  scale_color_manual(values = c('blue','red'))

#===============================================================================================================================


#ROS-RUS(both)

n_new<-nrow(train_data)
fraction_fraud_new<-0.5
sampling_result<-ovun.sample(Class~.,data = train_data,method="both",N=n_new,p=fraction_fraud_new,seed=2023)

sampled_credit<-sampling_result$data

table(sampled_credit$Class)

prop.table(table(sampled_credit$Class))


ggplot(data = sampled_credit,aes(x=V1,y=V2,col=Class))+
  geom_point(position = position_jitter(width = 0.2))+
  theme_bw()+
  scale_color_manual(values = c('blue','red'))

#===============================================================================================================================


#using smote to balance the dataset

table(train_data$Class)


#set the number of fraudulent and legitimate cases, and the desired percentage of legitimate cases

n0<-22750
n1<-35
r0<-0.6

#calculate the value for the dup_size parameter of SMOTE

ntimes<-((1-r0)/r0)*(n0/n1)-1
smote_output<-SMOTE(X=train_data[ , -c(1, 31)],
                    target = train_data$Class,
                    K=5,
                    dup_size = ntimes)


credit_smote<-smote_output$data

colnames(credit_smote)[30]<-"Class"

prop.table(table(credit_smote$Class))


ggplot(data = credit_smote,aes(x=V1,y=V2,col=Class))+
  geom_point(position = position_jitter(width = 0.2))+
  theme_bw()+
  scale_color_manual(values = c('blue','red'))


#==============================================================================================================================

#Decision tree using SMOTE

CART_model<-rpart(Class~.,credit_smote)

rpart.plot(CART_model,extra = 0,type = 5,tweak = 1.2)

#Important variables
varImp(CART_model)

#predict fraud classes
predicted_val<-predict(CART_model,test_data,type = "class")

#ROC curve

roc.curve(test_data$Class,predicted_val,plotit = TRUE)
#Area under the curve (AUC): 0.883

#build confusion matrix

confusionMatrix(predicted_val,test_data$Class)

#===============================================================================================================================

#Decision tree without SMOTE
CART_model<-rpart(Class~.,train_data[,-1])

rpart.plot(CART_model,extra = 0,type = 5,tweak = 1.2)

#Variable importance
varImp(CART_model)

#predict fraud classes
predicted_val<-predict(CART_model,test_data[,-1],type = "class")


#ROC curve

roc.curve(test_data$Class,predicted_val,plotit = TRUE)
#Area under the curve (AUC): 0.833

#build confusion matrix

confusionMatrix(predicted_val,test_data$Class)

#===============================================================================================================================

#now compare these two models using the whole data i.e the unbalanced 'credit_card' data

#model trained by actual train_data
CART_model<-rpart(Class~.,train_data[,-1])
predicted_val<-predict(CART_model,credit_card[,-1],type = "class")
confusionMatrix(predicted_val,credit_card$Class)

#model trained by SMOTE data
CART_model<-rpart(Class~.,credit_smote)
predicted_val<-predict(CART_model,credit_card[,-1],type = "class")
confusionMatrix(predicted_val,credit_card$Class)


#===============================================================================================================================

