# Practical Machine Learning: Human Activity Recognition
Uriel Tallon  
Saturday, September 10, 2016  

## 1. Context:

The following report is part of a required peer-reviewed assessment from the _Practical Machine Learning_ course, one of the ten courses from the __Coursera Data Science Specialty__ offered by Johns Hopkins University.

The report deals with the analysis of a particular dataset coming from [this source](http://groupware.les.inf.puc-rio.br/har) about Human Activity Recognition (HAR) but with a twist: most of the works on the subject deal with the identification of a particular task while this one focus on how well a task is performed. 

Six young health participants have been asked to perform one set of 10 repetitions of the unilateral dumbbell biceps curl in five different fashions which are the classes to predict:

| Classe  | Description                                           |
|---------|-------------------------------------------------------|
| __A__   | Exactly according to the specification                |
| __B__   | Throwing the elbows to the front                      |
| __C__   | Lifting the dubbell only halfway                      |
| __D__   | Lowering the dumbbell only halfway                    |
| __E__   | Throwing the hips to the front                        |

The class A corresponds to the specific execution of the exercise while the other 4 classes correspond to common mistakes. We will try to build a robust predction model that will predict the class of 20 different provided test cases.

The following libraries will be loaded:

* __knitr:__ for fancy tables.

* __caret & rpart:__ for data partition, model training and decision trees.



## 2. Data Loading & Training:

We will load both the full dataset and the 20 test cases to predict.


```r
raw <- read.csv("pml-training.csv")
testing <- read.csv("pml-testing.csv")
```

The row dataset looks like this.


  X  user_name    raw_timestamp_part_1   raw_timestamp_part_2  cvtd_timestamp     new_window    num_window   roll_belt   pitch_belt   yaw_belt   total_accel_belt  kurtosis_roll_belt   kurtosis_picth_belt   kurtosis_yaw_belt   skewness_roll_belt   skewness_roll_belt.1   skewness_yaw_belt    max_roll_belt   max_picth_belt  max_yaw_belt    min_roll_belt   min_pitch_belt  min_yaw_belt    amplitude_roll_belt   amplitude_pitch_belt  amplitude_yaw_belt    var_total_accel_belt   avg_roll_belt   stddev_roll_belt   var_roll_belt   avg_pitch_belt   stddev_pitch_belt   var_pitch_belt   avg_yaw_belt   stddev_yaw_belt   var_yaw_belt   gyros_belt_x   gyros_belt_y   gyros_belt_z   accel_belt_x   accel_belt_y   accel_belt_z   magnet_belt_x   magnet_belt_y   magnet_belt_z   roll_arm   pitch_arm   yaw_arm   total_accel_arm   var_accel_arm   avg_roll_arm   stddev_roll_arm   var_roll_arm   avg_pitch_arm   stddev_pitch_arm   var_pitch_arm   avg_yaw_arm   stddev_yaw_arm   var_yaw_arm   gyros_arm_x   gyros_arm_y   gyros_arm_z   accel_arm_x   accel_arm_y   accel_arm_z   magnet_arm_x   magnet_arm_y   magnet_arm_z  kurtosis_roll_arm   kurtosis_picth_arm   kurtosis_yaw_arm   skewness_roll_arm   skewness_pitch_arm   skewness_yaw_arm    max_roll_arm   max_picth_arm   max_yaw_arm   min_roll_arm   min_pitch_arm   min_yaw_arm   amplitude_roll_arm   amplitude_pitch_arm   amplitude_yaw_arm   roll_dumbbell   pitch_dumbbell   yaw_dumbbell  kurtosis_roll_dumbbell   kurtosis_picth_dumbbell   kurtosis_yaw_dumbbell   skewness_roll_dumbbell   skewness_pitch_dumbbell   skewness_yaw_dumbbell    max_roll_dumbbell   max_picth_dumbbell  max_yaw_dumbbell    min_roll_dumbbell   min_pitch_dumbbell  min_yaw_dumbbell    amplitude_roll_dumbbell   amplitude_pitch_dumbbell  amplitude_yaw_dumbbell    total_accel_dumbbell   var_accel_dumbbell   avg_roll_dumbbell   stddev_roll_dumbbell   var_roll_dumbbell   avg_pitch_dumbbell   stddev_pitch_dumbbell   var_pitch_dumbbell   avg_yaw_dumbbell   stddev_yaw_dumbbell   var_yaw_dumbbell   gyros_dumbbell_x   gyros_dumbbell_y   gyros_dumbbell_z   accel_dumbbell_x   accel_dumbbell_y   accel_dumbbell_z   magnet_dumbbell_x   magnet_dumbbell_y   magnet_dumbbell_z   roll_forearm   pitch_forearm   yaw_forearm  kurtosis_roll_forearm   kurtosis_picth_forearm   kurtosis_yaw_forearm   skewness_roll_forearm   skewness_pitch_forearm   skewness_yaw_forearm    max_roll_forearm   max_picth_forearm  max_yaw_forearm    min_roll_forearm   min_pitch_forearm  min_yaw_forearm    amplitude_roll_forearm   amplitude_pitch_forearm  amplitude_yaw_forearm    total_accel_forearm   var_accel_forearm   avg_roll_forearm   stddev_roll_forearm   var_roll_forearm   avg_pitch_forearm   stddev_pitch_forearm   var_pitch_forearm   avg_yaw_forearm   stddev_yaw_forearm   var_yaw_forearm   gyros_forearm_x   gyros_forearm_y   gyros_forearm_z   accel_forearm_x   accel_forearm_y   accel_forearm_z   magnet_forearm_x   magnet_forearm_y   magnet_forearm_z  classe 
---  ----------  ---------------------  ---------------------  -----------------  -----------  -----------  ----------  -----------  ---------  -----------------  -------------------  --------------------  ------------------  -------------------  ---------------------  ------------------  --------------  ---------------  -------------  --------------  ---------------  -------------  --------------------  ---------------------  -------------------  ---------------------  --------------  -----------------  --------------  ---------------  ------------------  ---------------  -------------  ----------------  -------------  -------------  -------------  -------------  -------------  -------------  -------------  --------------  --------------  --------------  ---------  ----------  --------  ----------------  --------------  -------------  ----------------  -------------  --------------  -----------------  --------------  ------------  ---------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  -------------  -------------  -------------  ------------------  -------------------  -----------------  ------------------  -------------------  -----------------  -------------  --------------  ------------  -------------  --------------  ------------  -------------------  --------------------  ------------------  --------------  ---------------  -------------  -----------------------  ------------------------  ----------------------  -----------------------  ------------------------  ----------------------  ------------------  -------------------  -----------------  ------------------  -------------------  -----------------  ------------------------  -------------------------  -----------------------  ---------------------  -------------------  ------------------  ---------------------  ------------------  -------------------  ----------------------  -------------------  -----------------  --------------------  -----------------  -----------------  -----------------  -----------------  -----------------  -----------------  -----------------  ------------------  ------------------  ------------------  -------------  --------------  ------------  ----------------------  -----------------------  ---------------------  ----------------------  -----------------------  ---------------------  -----------------  ------------------  ----------------  -----------------  ------------------  ----------------  -----------------------  ------------------------  ----------------------  --------------------  ------------------  -----------------  --------------------  -----------------  ------------------  ---------------------  ------------------  ----------------  -------------------  ----------------  ----------------  ----------------  ----------------  ----------------  ----------------  ----------------  -----------------  -----------------  -----------------  -------
  1  carlitos               1323084231                 788290  05/12/2011 11:23   no                    11        1.41         8.07      -94.4                  3                                                                                                                                             NA               NA                             NA               NA                                   NA                     NA                                          NA              NA                 NA              NA               NA                  NA               NA             NA                NA             NA           0.00           0.00          -0.02            -21              4             22              -3             599            -313       -128        22.5      -161                34              NA             NA                NA             NA              NA                 NA              NA            NA               NA            NA          0.00          0.00         -0.02          -288           109          -123           -368            337            516                                                                                                                                     NA              NA            NA             NA              NA            NA                   NA                    NA                  NA        13.05217        -70.49400      -84.87394                                                                                                                                                                        NA                   NA                                     NA                   NA                                           NA                         NA                                              37                   NA                  NA                     NA                  NA                   NA                      NA                   NA                 NA                    NA                 NA                  0              -0.02               0.00               -234                 47               -271                -559                 293                 -65           28.4           -63.9          -153                                                                                                                                                                 NA                  NA                                   NA                  NA                                         NA                        NA                                            36                  NA                 NA                    NA                 NA                  NA                     NA                  NA                NA                   NA                NA              0.03              0.00             -0.02               192               203              -215                -17                654                476  A      
  2  carlitos               1323084231                 808298  05/12/2011 11:23   no                    11        1.41         8.07      -94.4                  3                                                                                                                                             NA               NA                             NA               NA                                   NA                     NA                                          NA              NA                 NA              NA               NA                  NA               NA             NA                NA             NA           0.02           0.00          -0.02            -22              4             22              -7             608            -311       -128        22.5      -161                34              NA             NA                NA             NA              NA                 NA              NA            NA               NA            NA          0.02         -0.02         -0.02          -290           110          -125           -369            337            513                                                                                                                                     NA              NA            NA             NA              NA            NA                   NA                    NA                  NA        13.13074        -70.63751      -84.71065                                                                                                                                                                        NA                   NA                                     NA                   NA                                           NA                         NA                                              37                   NA                  NA                     NA                  NA                   NA                      NA                   NA                 NA                    NA                 NA                  0              -0.02               0.00               -233                 47               -269                -555                 296                 -64           28.3           -63.9          -153                                                                                                                                                                 NA                  NA                                   NA                  NA                                         NA                        NA                                            36                  NA                 NA                    NA                 NA                  NA                     NA                  NA                NA                   NA                NA              0.02              0.00             -0.02               192               203              -216                -18                661                473  A      
  3  carlitos               1323084231                 820366  05/12/2011 11:23   no                    11        1.42         8.07      -94.4                  3                                                                                                                                             NA               NA                             NA               NA                                   NA                     NA                                          NA              NA                 NA              NA               NA                  NA               NA             NA                NA             NA           0.00           0.00          -0.02            -20              5             23              -2             600            -305       -128        22.5      -161                34              NA             NA                NA             NA              NA                 NA              NA            NA               NA            NA          0.02         -0.02         -0.02          -289           110          -126           -368            344            513                                                                                                                                     NA              NA            NA             NA              NA            NA                   NA                    NA                  NA        12.85075        -70.27812      -85.14078                                                                                                                                                                        NA                   NA                                     NA                   NA                                           NA                         NA                                              37                   NA                  NA                     NA                  NA                   NA                      NA                   NA                 NA                    NA                 NA                  0              -0.02               0.00               -232                 46               -270                -561                 298                 -63           28.3           -63.9          -152                                                                                                                                                                 NA                  NA                                   NA                  NA                                         NA                        NA                                            36                  NA                 NA                    NA                 NA                  NA                     NA                  NA                NA                   NA                NA              0.03             -0.02              0.00               196               204              -213                -18                658                469  A      
  4  carlitos               1323084232                 120339  05/12/2011 11:23   no                    12        1.48         8.05      -94.4                  3                                                                                                                                             NA               NA                             NA               NA                                   NA                     NA                                          NA              NA                 NA              NA               NA                  NA               NA             NA                NA             NA           0.02           0.00          -0.03            -22              3             21              -6             604            -310       -128        22.1      -161                34              NA             NA                NA             NA              NA                 NA              NA            NA               NA            NA          0.02         -0.03          0.02          -289           111          -123           -372            344            512                                                                                                                                     NA              NA            NA             NA              NA            NA                   NA                    NA                  NA        13.43120        -70.39379      -84.87363                                                                                                                                                                        NA                   NA                                     NA                   NA                                           NA                         NA                                              37                   NA                  NA                     NA                  NA                   NA                      NA                   NA                 NA                    NA                 NA                  0              -0.02              -0.02               -232                 48               -269                -552                 303                 -60           28.1           -63.9          -152                                                                                                                                                                 NA                  NA                                   NA                  NA                                         NA                        NA                                            36                  NA                 NA                    NA                 NA                  NA                     NA                  NA                NA                   NA                NA              0.02             -0.02              0.00               189               206              -214                -16                658                469  A      
  5  carlitos               1323084232                 196328  05/12/2011 11:23   no                    12        1.48         8.07      -94.4                  3                                                                                                                                             NA               NA                             NA               NA                                   NA                     NA                                          NA              NA                 NA              NA               NA                  NA               NA             NA                NA             NA           0.02           0.02          -0.02            -21              2             24              -6             600            -302       -128        22.1      -161                34              NA             NA                NA             NA              NA                 NA              NA            NA               NA            NA          0.00         -0.03          0.00          -289           111          -123           -374            337            506                                                                                                                                     NA              NA            NA             NA              NA            NA                   NA                    NA                  NA        13.37872        -70.42856      -84.85306                                                                                                                                                                        NA                   NA                                     NA                   NA                                           NA                         NA                                              37                   NA                  NA                     NA                  NA                   NA                      NA                   NA                 NA                    NA                 NA                  0              -0.02               0.00               -233                 48               -270                -554                 292                 -68           28.0           -63.9          -152                                                                                                                                                                 NA                  NA                                   NA                  NA                                         NA                        NA                                            36                  NA                 NA                    NA                 NA                  NA                     NA                  NA                NA                   NA                NA              0.02              0.00             -0.02               189               206              -214                -17                655                473  A      

At first glance, we can see there are a lot of features that are either not used or undefined. We can compare with the testing dataset:


  X  user_name    raw_timestamp_part_1   raw_timestamp_part_2  cvtd_timestamp     new_window    num_window   roll_belt   pitch_belt   yaw_belt   total_accel_belt  kurtosis_roll_belt   kurtosis_picth_belt   kurtosis_yaw_belt   skewness_roll_belt   skewness_roll_belt.1   skewness_yaw_belt   max_roll_belt   max_picth_belt   max_yaw_belt   min_roll_belt   min_pitch_belt   min_yaw_belt   amplitude_roll_belt   amplitude_pitch_belt   amplitude_yaw_belt   var_total_accel_belt   avg_roll_belt   stddev_roll_belt   var_roll_belt   avg_pitch_belt   stddev_pitch_belt   var_pitch_belt   avg_yaw_belt   stddev_yaw_belt   var_yaw_belt    gyros_belt_x   gyros_belt_y   gyros_belt_z   accel_belt_x   accel_belt_y   accel_belt_z   magnet_belt_x   magnet_belt_y   magnet_belt_z   roll_arm   pitch_arm   yaw_arm   total_accel_arm  var_accel_arm   avg_roll_arm   stddev_roll_arm   var_roll_arm   avg_pitch_arm   stddev_pitch_arm   var_pitch_arm   avg_yaw_arm   stddev_yaw_arm   var_yaw_arm    gyros_arm_x   gyros_arm_y   gyros_arm_z   accel_arm_x   accel_arm_y   accel_arm_z   magnet_arm_x   magnet_arm_y   magnet_arm_z  kurtosis_roll_arm   kurtosis_picth_arm   kurtosis_yaw_arm   skewness_roll_arm   skewness_pitch_arm   skewness_yaw_arm   max_roll_arm   max_picth_arm   max_yaw_arm   min_roll_arm   min_pitch_arm   min_yaw_arm   amplitude_roll_arm   amplitude_pitch_arm   amplitude_yaw_arm    roll_dumbbell   pitch_dumbbell   yaw_dumbbell  kurtosis_roll_dumbbell   kurtosis_picth_dumbbell   kurtosis_yaw_dumbbell   skewness_roll_dumbbell   skewness_pitch_dumbbell   skewness_yaw_dumbbell   max_roll_dumbbell   max_picth_dumbbell   max_yaw_dumbbell   min_roll_dumbbell   min_pitch_dumbbell   min_yaw_dumbbell   amplitude_roll_dumbbell   amplitude_pitch_dumbbell   amplitude_yaw_dumbbell    total_accel_dumbbell  var_accel_dumbbell   avg_roll_dumbbell   stddev_roll_dumbbell   var_roll_dumbbell   avg_pitch_dumbbell   stddev_pitch_dumbbell   var_pitch_dumbbell   avg_yaw_dumbbell   stddev_yaw_dumbbell   var_yaw_dumbbell    gyros_dumbbell_x   gyros_dumbbell_y   gyros_dumbbell_z   accel_dumbbell_x   accel_dumbbell_y   accel_dumbbell_z   magnet_dumbbell_x   magnet_dumbbell_y   magnet_dumbbell_z   roll_forearm   pitch_forearm   yaw_forearm  kurtosis_roll_forearm   kurtosis_picth_forearm   kurtosis_yaw_forearm   skewness_roll_forearm   skewness_pitch_forearm   skewness_yaw_forearm   max_roll_forearm   max_picth_forearm   max_yaw_forearm   min_roll_forearm   min_pitch_forearm   min_yaw_forearm   amplitude_roll_forearm   amplitude_pitch_forearm   amplitude_yaw_forearm    total_accel_forearm  var_accel_forearm   avg_roll_forearm   stddev_roll_forearm   var_roll_forearm   avg_pitch_forearm   stddev_pitch_forearm   var_pitch_forearm   avg_yaw_forearm   stddev_yaw_forearm   var_yaw_forearm    gyros_forearm_x   gyros_forearm_y   gyros_forearm_z   accel_forearm_x   accel_forearm_y   accel_forearm_z   magnet_forearm_x   magnet_forearm_y   magnet_forearm_z   problem_id
---  ----------  ---------------------  ---------------------  -----------------  -----------  -----------  ----------  -----------  ---------  -----------------  -------------------  --------------------  ------------------  -------------------  ---------------------  ------------------  --------------  ---------------  -------------  --------------  ---------------  -------------  --------------------  ---------------------  -------------------  ---------------------  --------------  -----------------  --------------  ---------------  ------------------  ---------------  -------------  ----------------  -------------  -------------  -------------  -------------  -------------  -------------  -------------  --------------  --------------  --------------  ---------  ----------  --------  ----------------  --------------  -------------  ----------------  -------------  --------------  -----------------  --------------  ------------  ---------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  -------------  -------------  -------------  ------------------  -------------------  -----------------  ------------------  -------------------  -----------------  -------------  --------------  ------------  -------------  --------------  ------------  -------------------  --------------------  ------------------  --------------  ---------------  -------------  -----------------------  ------------------------  ----------------------  -----------------------  ------------------------  ----------------------  ------------------  -------------------  -----------------  ------------------  -------------------  -----------------  ------------------------  -------------------------  -----------------------  ---------------------  -------------------  ------------------  ---------------------  ------------------  -------------------  ----------------------  -------------------  -----------------  --------------------  -----------------  -----------------  -----------------  -----------------  -----------------  -----------------  -----------------  ------------------  ------------------  ------------------  -------------  --------------  ------------  ----------------------  -----------------------  ---------------------  ----------------------  -----------------------  ---------------------  -----------------  ------------------  ----------------  -----------------  ------------------  ----------------  -----------------------  ------------------------  ----------------------  --------------------  ------------------  -----------------  --------------------  -----------------  ------------------  ---------------------  ------------------  ----------------  -------------------  ----------------  ----------------  ----------------  ----------------  ----------------  ----------------  ----------------  -----------------  -----------------  -----------------  -----------
  1  pedro                  1323095002                 868349  05/12/2011 14:23   no                    74      123.00        27.00      -4.75                 20  NA                   NA                    NA                  NA                   NA                     NA                  NA              NA               NA             NA              NA               NA             NA                    NA                     NA                   NA                     NA              NA                 NA              NA               NA                  NA               NA             NA                NA                     -0.50          -0.02          -0.46            -38             69           -179             -13             581            -382       40.7      -27.80       178                10  NA              NA             NA                NA             NA              NA                 NA              NA            NA               NA                   -1.65          0.48         -0.18            16            38            93           -326            385            481  NA                  NA                   NA                 NA                  NA                   NA                 NA             NA              NA            NA             NA              NA            NA                   NA                    NA                       -17.73748         24.96085      126.23596  NA                       NA                        NA                      NA                       NA                        NA                      NA                  NA                   NA                 NA                  NA                   NA                 NA                        NA                         NA                                           9  NA                   NA                  NA                     NA                  NA                   NA                      NA                   NA                 NA                    NA                              0.64               0.06              -0.61                 21                -15                 81                 523                -528                 -56            141           49.30         156.0  NA                      NA                       NA                     NA                      NA                       NA                     NA                 NA                  NA                NA                 NA                  NA                NA                       NA                        NA                                        33  NA                  NA                 NA                    NA                 NA                  NA                     NA                  NA                NA                   NA                            0.74             -3.34             -0.59              -110               267              -149               -714                419                617            1
  2  jeremy                 1322673067                 778725  30/11/2011 17:11   no                   431        1.02         4.87     -88.90                  4  NA                   NA                    NA                  NA                   NA                     NA                  NA              NA               NA             NA              NA               NA             NA                    NA                     NA                   NA                     NA              NA                 NA              NA               NA                  NA               NA             NA                NA                     -0.06          -0.02          -0.07            -13             11             39              43             636            -309        0.0        0.00         0                38  NA              NA             NA                NA             NA              NA                 NA              NA            NA               NA                   -1.17          0.85         -0.43          -290           215           -90           -325            447            434  NA                  NA                   NA                 NA                  NA                   NA                 NA             NA              NA            NA             NA              NA            NA                   NA                    NA                        54.47761        -53.69758      -75.51480  NA                       NA                        NA                      NA                       NA                        NA                      NA                  NA                   NA                 NA                  NA                   NA                 NA                        NA                         NA                                          31  NA                   NA                  NA                     NA                  NA                   NA                      NA                   NA                 NA                    NA                              0.34               0.05              -0.71               -153                155               -205                -502                 388                 -36            109          -17.60         106.0  NA                      NA                       NA                     NA                      NA                       NA                     NA                 NA                  NA                NA                 NA                  NA                NA                       NA                        NA                                        39  NA                  NA                 NA                    NA                 NA                  NA                     NA                  NA                NA                   NA                            1.12             -2.78             -0.18               212               297              -118               -237                791                873            2
  3  jeremy                 1322673075                 342967  30/11/2011 17:11   no                   439        0.87         1.82     -88.50                  5  NA                   NA                    NA                  NA                   NA                     NA                  NA              NA               NA             NA              NA               NA             NA                    NA                     NA                   NA                     NA              NA                 NA              NA               NA                  NA               NA             NA                NA                      0.05           0.02           0.03              1             -1             49              29             631            -312        0.0        0.00         0                44  NA              NA             NA                NA             NA              NA                 NA              NA            NA               NA                    2.10         -1.36          1.13          -341           245           -87           -264            474            413  NA                  NA                   NA                 NA                  NA                   NA                 NA             NA              NA            NA             NA              NA            NA                   NA                    NA                        57.07031        -51.37303      -75.20287  NA                       NA                        NA                      NA                       NA                        NA                      NA                  NA                   NA                 NA                  NA                   NA                 NA                        NA                         NA                                          29  NA                   NA                  NA                     NA                  NA                   NA                      NA                   NA                 NA                    NA                              0.39               0.14              -0.34               -141                155               -196                -506                 349                  41            131          -32.60          93.0  NA                      NA                       NA                     NA                      NA                       NA                     NA                 NA                  NA                NA                 NA                  NA                NA                       NA                        NA                                        34  NA                  NA                 NA                    NA                 NA                  NA                     NA                  NA                NA                   NA                            0.18             -0.79              0.28               154               271              -129                -51                698                783            3
  4  adelmo                 1322832789                 560311  02/12/2011 13:33   no                   194      125.00       -41.60     162.00                 17  NA                   NA                    NA                  NA                   NA                     NA                  NA              NA               NA             NA              NA               NA             NA                    NA                     NA                   NA                     NA              NA                 NA              NA               NA                  NA               NA             NA                NA                      0.11           0.11          -0.16             46             45           -156             169             608            -304     -109.0       55.00      -142                25  NA              NA             NA                NA             NA              NA                 NA              NA            NA               NA                    0.22         -0.51          0.92          -238           -57             6           -173            257            633  NA                  NA                   NA                 NA                  NA                   NA                 NA             NA              NA            NA             NA              NA            NA                   NA                    NA                        43.10927        -30.04885     -103.32003  NA                       NA                        NA                      NA                       NA                        NA                      NA                  NA                   NA                 NA                  NA                   NA                 NA                        NA                         NA                                          18  NA                   NA                  NA                     NA                  NA                   NA                      NA                   NA                 NA                    NA                              0.10              -0.02               0.05                -51                 72               -148                -576                 238                  53              0            0.00           0.0  NA                      NA                       NA                     NA                      NA                       NA                     NA                 NA                  NA                NA                 NA                  NA                NA                       NA                        NA                                        43  NA                  NA                 NA                    NA                 NA                  NA                     NA                  NA                NA                   NA                            1.38              0.69              1.80               -92               406               -39               -233                783                521            4
  5  eurico                 1322489635                 814776  28/11/2011 14:13   no                   235        1.35         3.33     -88.60                  3  NA                   NA                    NA                  NA                   NA                     NA                  NA              NA               NA             NA              NA               NA             NA                    NA                     NA                   NA                     NA              NA                 NA              NA               NA                  NA               NA             NA                NA                      0.03           0.02           0.00             -8              4             27              33             566            -418       76.1        2.76       102                29  NA              NA             NA                NA             NA              NA                 NA              NA            NA               NA                   -1.96          0.79         -0.54          -197           200           -30           -170            275            617  NA                  NA                   NA                 NA                  NA                   NA                 NA             NA              NA            NA             NA              NA            NA                   NA                    NA                      -101.38396        -53.43952      -14.19542  NA                       NA                        NA                      NA                       NA                        NA                      NA                  NA                   NA                 NA                  NA                   NA                 NA                        NA                         NA                                           4  NA                   NA                  NA                     NA                  NA                   NA                      NA                   NA                 NA                    NA                              0.29              -0.47              -0.46                -18                -30                 -5                -424                 252                 312           -176           -2.16         -47.9  NA                      NA                       NA                     NA                      NA                       NA                     NA                 NA                  NA                NA                 NA                  NA                NA                       NA                        NA                                        24  NA                  NA                 NA                    NA                 NA                  NA                     NA                  NA                NA                   NA                           -0.75              3.10              0.80               131               -93               172                375               -787                 91            5

Therefore, we will keep only the features that hold defined values in both datasets. The undefined or unfilled features will be dropped. The classes to be predicted are under the _classe_ label:


```r
feats <- c("user_name", "raw_timestamp_part_1", "raw_timestamp_part_2",
           "cvtd_timestamp", "new_window", "num_window", "roll_belt", "pitch_belt",
           "yaw_belt", "total_accel_belt", "gyros_belt_x", "gyros_belt_y",
           "gyros_belt_z", "accel_belt_x", "accel_belt_y", "accel_belt_z",
           "magnet_belt_x", "magnet_belt_y", "magnet_belt_z", "roll_arm",
           "pitch_arm", "yaw_arm", "total_accel_arm", "gyros_arm_x", "gyros_arm_y",
           "gyros_arm_z", "accel_arm_x", "accel_arm_y", "accel_arm_z","magnet_arm_x",
           "magnet_arm_y", "magnet_arm_z", "roll_dumbbell","pitch_dumbbell",
           "yaw_dumbbell", "total_accel_dumbbell", "gyros_dumbbell_x",
           "gyros_dumbbell_y", "gyros_dumbbell_z", "accel_dumbbell_x",
           "accel_dumbbell_y", "accel_dumbbell_z", "magnet_dumbbell_x",
           "magnet_dumbbell_y", "magnet_dumbbell_z", "roll_forearm", "pitch_forearm",
           "yaw_forearm", "gyros_forearm_x", "gyros_forearm_y", "gyros_forearm_z",
           "accel_forearm_x", "accel_forearm_y", "accel_forearm_z", "magnet_forearm_x",
           "magnet_forearm_y", "magnet_forearm_z")
outcome <- c("classe")
```

That's a total of 57 features.

## 3. Models Training & Validation:

The first step is to split the raw dataset between training and validation set. The data will be split as following:

* 80% for the training set

* 20% for the validation set


```r
set.seed(342)
trainIdx <- createDataPartition(raw$classe, p = 0.8 ,list = FALSE)
training <- raw[trainIdx,]
training <- training[, c(outcome, feats)]
validating <- raw[-trainIdx,]
testing <- testing[, c(feats)]
```

### a. Basic Decision Tree:

The first model will be a simple decision tree with default parameters: 


```r
fit.bas <- train(classe ~ . , method = "rpart", data = training)
pred.bas <- predict(fit.bas, validating[, feats])
conf.bas <- confusionMatrix(validating$classe, pred.bas)
```

The default model uses bootstrap with 25 repetitions. The results are:


```
##           cp  Accuracy      Kappa AccuracySD    KappaSD
## 1 0.03368936 0.6438081 0.54880856 0.05265641 0.06580384
## 2 0.03441626 0.6278765 0.52565154 0.07565012 0.10568242
## 3 0.11410770 0.3262640 0.06366904 0.04236393 0.06250448
```

The selected model is the one with the complexity parameter of 0.034, with an accuracy on the training set of 0.644. The model accuracy on the validating set is 0.63, which is not bad for a first try. A quick look on the confusion matrix can give an idea of the different mismatch:


```
##           Reference
## Prediction   A   B   C   D   E
##          A 842  67  59 146   2
##          B 193 322 123 121   0
##          C  11   7 381 285   0
##          D  40   0  21 582   0
##          E   4   0  41 339 337
```

There are a few mismatche in class A and C. B and E are predicted with little inaccuracy. On the other hand, class D is really messy.

### b. Principal Component Analysis:

The second model will take advantage of principal component analysis, in order to reduce the number of features and possibly increase accuracy by reducing model complexity (thus preventing over-fitting). The parameters are set so that the PCA will determine the required number of components to capture 90% of the variance of the dataset:


```r
proc.pca <- preProcess(training, method = "pca", outcome = training$classe, thresh = 0.8)
pred.train <- predict(proc.pca, training)
pred.test <- predict(proc.pca, validating[, c(outcome, feats)])
fit.pca <- train(classe ~ . , method = "rpart", data = pred.train)
pred.pca <- predict(fit.pca, pred.test)
conf.pca <- confusionMatrix(validating$classe, pred.pca)
```

The PCA gives 13 components required to capture 80% of the variance. The model fitting still uses bootstrap with 25 repetitions. The results are:


```
##           cp  Accuracy     Kappa AccuracySD   KappaSD
## 1 0.02218514 0.5100774 0.3559937  0.1455169 0.2292029
## 2 0.02287494 0.5047779 0.3494546  0.1425280 0.2254135
## 3 0.02576769 0.4016407 0.1936239  0.1382167 0.2254606
```

The selected model is the one with the complexity parameter of 0.022, with an accuracy on the training set of 0.51. The model accuracy on the validating set is 0.53, which is lower than the accuracy of the basic model.

The confusion matrix is:


```
##           Reference
## Prediction   A   B   C   D   E
##          A 652 139 325   0   0
##          B 135 205 419   0   0
##          C   0  41 639   0   4
##          D   0   0 351   0 292
##          E   0   0 140   0 581
```

Apparently the model is not able to identify class D.

### c. Repeated Cross-Validation:

Now, let's try to get more control on the training process. The method used is a _repeated cross-validation_ with 10 folds and 4 repetitions. The research grid will look over the complexity parameter of the model, checking for values from 0 to 0.1 with an increment of 0.005.


```r
ctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 4, search = "grid")
newgrid <- expand.grid(cp = seq(0, 0.1, 0.005))
fit.ctr <- train(classe ~ . , method = "rpart",
                 data = training, trControl = ctrl,
                 tuneGrid = newgrid)
pred.ctr <- predict(fit.ctr, validating[, feats])
conf.ctr <- confusionMatrix(validating$classe, pred.ctr)
```

The training results are:


```
##       cp  Accuracy     Kappa  AccuracySD     KappaSD
## 1  0.000 0.9855888 0.9817713 0.004010523 0.005072592
## 2  0.005 0.9350287 0.9178588 0.009983745 0.012644075
## 3  0.010 0.8908078 0.8620807 0.033524596 0.042298873
## 4  0.015 0.8483703 0.8087266 0.035267599 0.044230977
## 5  0.020 0.8111718 0.7616901 0.033262306 0.042106106
## 6  0.025 0.7697219 0.7088150 0.051473524 0.064896206
## 7  0.030 0.6735819 0.5884101 0.038673038 0.048872063
## 8  0.035 0.5213502 0.3665864 0.132754367 0.204968436
## 9  0.040 0.4665286 0.2895356 0.103281554 0.168530068
## 10 0.045 0.4044306 0.1901884 0.076313423 0.127771867
## 11 0.050 0.3660103 0.1243353 0.003791158 0.005705703
## 12 0.055 0.3660103 0.1243353 0.003791158 0.005705703
## 13 0.060 0.3660103 0.1243353 0.003791158 0.005705703
## 14 0.065 0.3660103 0.1243353 0.003791158 0.005705703
## 15 0.070 0.3660103 0.1243353 0.003791158 0.005705703
## 16 0.075 0.3660103 0.1243353 0.003791158 0.005705703
## 17 0.080 0.3660103 0.1243353 0.003791158 0.005705703
## 18 0.085 0.3660103 0.1243353 0.003791158 0.005705703
## 19 0.090 0.3660103 0.1243353 0.003791158 0.005705703
## 20 0.095 0.3660103 0.1243353 0.003791158 0.005705703
## 21 0.100 0.3660103 0.1243353 0.003791158 0.005705703
```

The selected model is the one with the complexity parameter of 0, with an accuracy on the training set of 0.986. The model accuracy on the validating set is 0.99, which is very good (suspiciously good, dare I say).

The confusion matrix shows that all classes are very well predicted:


```
##           Reference
## Prediction    A    B    C    D    E
##          A 1115    1    0    0    0
##          B    6  750    3    0    0
##          C    0    3  676    3    2
##          D    0    4    1  632    6
##          E    0    0    0    4  717
```

## 4. Testing & Conclusion:

The results of the testing are the following:


```
##    basic pca control
## 1      D   C       B
## 2      C   C       A
## 3      C   C       B
## 4      A   A       A
## 5      A   A       A
## 6      D   E       E
## 7      D   E       D
## 8      C   C       B
## 9      A   B       A
## 10     A   A       A
## 11     B   B       B
## 12     C   C       C
## 13     B   C       B
## 14     A   A       A
## 15     D   E       E
## 16     D   E       E
## 17     D   C       A
## 18     B   B       B
## 19     D   C       B
## 20     B   C       B
```

Applying the results of the __control__ column yields 100% correct results on the project quizz.
