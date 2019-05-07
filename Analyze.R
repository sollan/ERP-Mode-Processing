# Set up ------------------------------------------------------------------

library(readxl)
library(ggplot2)
library(graphics)
library(car)
library(stargazer)
library("smbinning")
library("InformationValue")
library("plotROC")

info <- read.csv("C:/Users/Annette/Desktop/Analysis/ppinfo.csv")
NN <- read.csv("C:/Users/Annette/Desktop/Data/Log/NN.csv")
NM <- read.csv("C:/Users/Annette/Desktop/Data/Log/NM.csv")
TN <- read.csv("C:/Users/Annette/Desktop/Data/Log/TN.csv")
TM <- read.csv("C:/Users/Annette/Desktop/Data/Log/TM.csv")

NN$Group <- "NN"
NN$Music <- "Nonmusician"
NN$Language <- "Intonation"
NM$Group <- "NM"
NM$Music <- "Musician"
NM$Language <- "Intonation"
TN$Group <- "TN"
TN$Music <- "Nonmusician"
TN$Language <- "Tonal"
TM$Group <- "TM"
TM$Music <- "Musician"
TM$Language <- "Tonal"

# NM might exclude: 8 *28 30 52 *69 70; M might exclude: 1 2 *41 68
# 9 38 as T
# NT might exclude: *22 (1yr tonal experience)




NN$ID <- rep(1:(length(NN$Group)/96), each = 96)
NM$ID <- rep(1:(length(NM$Group)/96), each = 96)
TN$ID <- rep(1:(length(TN$Group)/96), each = 96)
TM$ID <- rep(1:(length(TM$Group)/96), each = 96)


# Combine -----------------------------------------------------------------

responses <- rbind(NN, NM, TN, TM)
responses$PP <- rep(1:(length(responses$ID)/96), each = 96)
#View(responses)

responses$Res_type[responses$Res_type == 0] <- 2
responses$Res_type[responses$Res_type == 1] <- 0
responses$Res_type[responses$Res_type == 2] <- 1

par(mfrow = c(2,2))
hist(responses$Res_type[responses$Group == "NN"])
hist(responses$Res_type[responses$Group == "NM"])
hist(responses$Res_type[responses$Group == "TN"])
hist(responses$Res_type[responses$Group == "TM"])



# Re-label ----------------------------------------------------------------

levels(responses$Res_type) <- c("Correct", "Incorrect")
levels(responses$Response) <- c("major", "minor")
#View(responses)
write.csv(responses, file = "C:/Users/Annette/Desktop/Data/responses.csv", row.names = FALSE)

# Plot --------------------------------------------------------------------

summary(responses$Res_type[responses$Group == "NN" & responses$Stim_type == "major" & responses$Tempo_type == "fast"])
summary(responses$Res_type[responses$Group == "NM" & responses$Stim_type == "major" & responses$Tempo_type == "fast"])
summary(responses$Res_type[responses$Group == "TN" & responses$Stim_type == "major" & responses$Tempo_type == "fast"])
summary(responses$Res_type[responses$Group == "TM" & responses$Stim_type == "major" & responses$Tempo_type == "fast"])

summary(responses$Res_type[responses$Group == "NN" & responses$Stim_type == "minor" & responses$Tempo_type == "slow"])
summary(responses$Res_type[responses$Group == "NM" & responses$Stim_type == "minor" & responses$Tempo_type == "slow"])
summary(responses$Res_type[responses$Group == "TN" & responses$Stim_type == "minor" & responses$Tempo_type == "slow"])
summary(responses$Res_type[responses$Group == "TM" & responses$Stim_type == "minor" & responses$Tempo_type == "slow"])

summary(responses$Res_type[responses$Group == "NN" | responses$Group == "NM"])
summary(responses$Res_type[responses$Group == "TN" | responses$Group == "TM"])

summary(responses$Res_type[responses$Group == "NM" | responses$Group == "TM"])
summary(responses$Res_type[responses$Group == "NN" | responses$Group == "TN"])



# Compare Means -------------------------------------------------------------------

summary(responses$Res_type[responses$Group == "NN"])
summary(responses$Res_type[responses$Group == "NM"])
summary(responses$Res_type[responses$Group == "TN"])
summary(responses$Res_type[responses$Group == "TM"])

responses$Congruence[responses$Tempo_type == "fast" & responses$Stim_type == "major"] <- "congruent"
responses$Congruence[responses$Tempo_type == "slow" & responses$Stim_type == "minor"] <- "congruent"
responses$Congruence[responses$Tempo_type == "fast" & responses$Stim_type == "minor"] <- "incongruent"
responses$Congruence[responses$Tempo_type == "slow" & responses$Stim_type == "major"] <- "incongruent"

par(mfrow = c(2,4))
hist(responses$Res_type[responses$Group == "NN"])
hist(responses$Res_type[responses$Group == "NM"])
hist(responses$Res_type[responses$Group == "TN"])
hist(responses$Res_type[responses$Group == "TM"])
hist(responses$Res_type[responses$Group == "NN" & responses$Contingency == "congruent"])
hist(responses$Res_type[responses$Group == "NM" & responses$Contingency == "congruent"])
hist(responses$Res_type[responses$Group == "TN" & responses$Contingency == "congruent"])
hist(responses$Res_type[responses$Group == "TM" & responses$Contingency == "congruent"])

NN.new <- subset(responses, responses$Group == "NN")
NM.new <- subset(responses, responses$Group == "NM")
TN.new <- subset(responses, responses$Group == "TN")
TM.new <- subset(responses, responses$Group == "TM")



# ANOVA -------------------------------------------------------------------
anova <- aov(Res_type ~ Language * Music * Congruence, responses)
summary(anova)
TukeyHSD(anova)


# Anova with percentage data ----------------------------------------------
library(readxl)
Correct_response_rate <- read_excel("C:/Users/Annette/Desktop/Correct response rate.xlsx", 
                                     col_types = c("numeric", "numeric", "text", 
                                                    "text", "text"))

# between subject: Music, Language
# within subject: Congruence

par(mfrow=c(1,1))
f <- ggplot() + 
  geom_boxplot(aes(Correct_response_rate$Music, Correct_response_rate$Correct_response)) +
  geom_boxplot(aes(Correct_response_rate$Language, Correct_response_rate$Correct_response))

f
anova <- aov(Correct_response ~ Language * Music * Congruence, Correct_response_rate)
summary(anova)
posthoc <- TukeyHSD(anova)
posthoc
library(stargazer)
stargazer(posthoc)


# Logistic regression 1 ---------------------------------------------------

# Logistic regression with groups
logistic <- glm(Res_type ~ Language * Music,
                family = "binomial", data = responses)

summary(logistic)
stargazer(logistic)
vif(logistic)
try <- predict(logistic, responses, type="response")
plotROC(responses$Res_type, try)

Anova(logistic, type="III", test="Wald")

# Logistic regression 2 ---------------------------------------------------

# Logistic regression with groups and congruence (tempo vs. mode)
logistic2 <- glm(Res_type ~ Language + Music + Congruence,
                family = "binomial", data = responses)

summary(logistic2)
stargazer(logistic2)
vif(logistic2)
try2 <- predict(logistic2, responses, type="response")
plotROC(responses$Res_type, try2)

Anova(logistic2, type="III", test="Wald")

# Interaction plots -------------------------------------------------------

library(ggplot2)
library(ggpubr)



tonal_group <- subset(Correct_response_rate, Correct_response_rate$Language == 'Tonal')
intonation_group <- subset(Correct_response_rate, Correct_response_rate$Language == 'Intonation')

#ggerrorplot(Correct_response_rate, x = Correct_response_rate$Music, y = Correct_response_rate$Correct_response, mean)

#calculate means for each type x treatment 

#means <- by(tonal$Correct_response,list(dat$type,dat$treatment),mean) 

m.tm <- mean(tonal_group$Correct_response[tonal_group$Music == "Musician"])
m.tnm <- mean(tonal_group$Correct_response[tonal_group$Music == "Nonmusician"])
m.ntm <- mean(intonation_group$Correct_response[intonation_group$Music == "Musician"])
m.ntnm <- mean(intonation_group$Correct_response[intonation_group$Music == "Nonmusician"])

# a function for calculating standard error 
se <- function(x) sqrt(var(x) / length(x)) 

#now calculate standard error for each type x treatment 
#ses=by(dat$response,list(dat$type,dat$treatment),se) 


se.tm <- se(tonal_group$Correct_response[tonal_group$Music == "Musician"])
se.tnm <- se(tonal_group$Correct_response[tonal_group$Music == "Nonmusician"])
se.ntm <- se(intonation_group$Correct_response[intonation_group$Music == "Musician"])
se.ntnm <- se(intonation_group$Correct_response[intonation_group$Music == "Nonmusician"])

#now add the standard error lines (means plus/minus standard error) 

# lines(c(1,1),c(means[1]-ses[1],means[1]+ses[1])) 
# lines(c(1,1),c(means[2]-ses[2],means[2]+ses[2])) 
# lines(c(2,2),c(means[3]-ses[3],means[3]+ses[3])) 
# lines(c(2,2),c(means[4]-ses[4],means[4]+ses[4]))

par(mfrow = c(1,1))

interaction.plot(x.factor = Correct_response_rate$Music, 
                 trace.factor = Correct_response_rate$Language, 
                 response = Correct_response_rate$Correct_response, 
                 ylim = c(0.6,1),
                 fun = mean, 
                 type = "l", legend = T, lwd = 2,
                 axes = F, xpd = NA, xaxt = T,
                 trace.label = "Language group",
                 xlab = "Musical experience", ylab="Correct response rate")


axis(2, at = seq(0.6,1,0.05))
axis(1, at = c(1,2), labels = c("Musician","Nonmusician"))

lines(c(1,1), c(m.tm - se.tm, m.tm + se.tm))
lines(c(2,2), c(m.tnm - se.tnm, m.tnm + se.tnm))
lines(c(1,1), c(m.ntm - se.ntm, m.ntm + se.ntm))
lines(c(2,2), c(m.ntnm - se.ntnm, m.ntnm + se.ntnm))


            
interaction.plot(x.factor = Correct_response_rate$Language, 
                 trace.factor = Correct_response_rate$Music, 
                 response = Correct_response_rate$Correct_response, 
                 ylim = c(0.6,1),
                 fun = mean, 
                 type = "l", legend = T, lwd = 2,
                 axes = F, xpd = NA, xaxt = T,
                 trace.label = "Music group",
                 xlab = "Language experience", ylab="Correct response rate")


axis(2, at = seq(0.6,1,0.05))
axis(1, at = c(1,2), labels = c("Intonation","Tonal"))

lines(c(2,2), c(m.tm - se.tm, m.tm + se.tm))
lines(c(2,2), c(m.tnm - se.tnm, m.tnm + se.tnm))
lines(c(1,1), c(m.ntm - se.ntm, m.ntm + se.ntm))
lines(c(1,1), c(m.ntnm - se.ntnm, m.ntnm + se.ntnm))
