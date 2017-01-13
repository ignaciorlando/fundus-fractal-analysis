# Fractal features for proliferative diabetic retinopathy screening

This code corresponds to our submission to *Physics in Medicine and Biology* with Hugo Luis Manterola and Alejandro Clausse, entitled **"On viability of combining fractal features with machine learning for proliferative diabetic retinopathy screening"**.

If you use this code in any publication, please include the following citation:
```
	@article{orlando2017fractal,
	  title={On viability of combining fractal features with machine learning for proliferative diabetic retinopathy screening},
	  author={Orlando, Jos\'e Ignacio and Manterola, Hugo Luis and Clausse, Alejandro},
	  journal={Physics in Medicine and Biology},
	  pages={Submitted},
	  year={2017},
	  publisher={IOP Publishing}
	}
```
##Abstract

Diabetic retinopathy (DR) is one of the most spread causes of preventable blindness in the World. The most dangerous stage of this condition is known as proliferative DR, in which vision loss risk is high and treatments are considerable less effective. Fractal dimensions have been extensively explored as biomarkers of several ophthalmological and system diseases. However, current literature shows contradictory conclusions with respect to the viability of using fractal dimensions for DR screening. Moreover, recent studies have suggested to avoid their usage due to their numerical instability with respect to different imaging conditions. To the best of our knowledge, however, no study on how machine learning techniques might improve the discriminative power of fractal dimensions or measurements is currently available. In this paper we present a comprehensive analysis of the viability of using 3 reference fractal dimensions and measurements--box, information and correlation--as input features for training regularized logistic regression classifiers. Our results on a publicly available data set of 1200 images indicate that combining both fractal measurements and dimensions as features for a regularized logistic regression classifier is suitable for proliferative DR screening, reporting an area under the receiver-operating characteristic curve of 0.8521.


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. .

### Prerequisites

We make use of some external libraries in our code, namely:

 - VLFeat: for efficient ROC curve computation. [[link]](https://github.com/vlfeat/vlfeat)
 - Mark Schmidt implementation of regularized logistic regression. [[link]](https://www.cs.ubc.ca/~schmidtm/Software/code.html)

These two libraries are included by default in `fundus-fractal-analysis/external`.

It will also require to download MESSIDOR data set, which is available [here](www.adcis.net/en/Download-Third-Party/Messidor.html). Vascular segmentations of this data set, obtained using this method, can be downloaded from [here](https://app.box.com/s/66y5hyvj705lir82ckt89wan693fdb4r).

### Installing

 1. Create a fork of this repository, or clone it by doing:
```
$ git clone https://github.com/ignaciorlando/fundus-fractal-analysis
```
 2. Open MATLAB (I used MATLAB R2015a) and move to `fundus-fractal-analysis` folder.
 3. Run `setup_fractal` to compile all MEX files and to add necessary folders to the MATLAB path.
 4. Download MESSIDOR and segmentations.
 5. Edit `configuration_files/data_organization/config_organize_messidor_data` to indicate where the downloaded MESSIDOR data set is located.
 5. Run `data_organization/script_organize_messidor_data` to setup MESSIDOR in the correct form. This may take a while, as it will copy all the images to a new folder, preparing a .MAT files with the image labels, and it will generate field of view (FOV) masks for all the images in the data set and crop them around the FOV for faster processing.
 6. Copy the segmentations that you downloaded to the new MESSIDOR folder.
 7. Everything is ready to run!

> **Note:** We tested this code on a Macbook PRO Retina 2015 with macOS Sierra, but in principle there would be no problem on using it within other architectures or operating systems.

## Running experiments

Scripts for running experiments is in the `experiments` folder. All filenames are quite self-explanatory, but if you have any questions do not hesitate in opening issues in my github repository.

In general, all experiments will require to edit a configuration script. They are all in `configuration_files`.

### Fractal feature extraction

Scripts for fractal feature extraction are in the `feature-extraction` folder, and their configuration files are in `configuration_files/feature-extraction`.

Two different scripts for extracting features are available:

 - Run `script_extract_fractal_dimensions` to get fractal dimensions from all the images in MESSIDOR.
 - Run `script_extract_fractal_features` to get fractal measurements from all the images in MESSIDOR.

### Correlation analysis

- Run `script_perform_correlation_analysis` to estimate linear correlation between different fractal dimensions (Table 1 from our paper).

### Boxplots with fractal dimensions distribution per DR grade

- Run `script_boxplot_fractal_dimension_for_each_label` to get boxplots depicting fractal dimensions distribution per DR grade (Figures 2 and 3 from our paper).

### Boxplots with fractal dimensions distribution for proliferative DR screening

- Run `script_boxplot_proliferative_dr_screening` to get boxplots depicting fractal dimensions distribution for proliferative DR screening (Figures 4 and 5 from our paper).

### Wilcoxon rank sum tests between DR grades

- Run `script_wilk_test_between_grades` to perform Wilcoxon rank sum tests and estimate if differences in distributions between grades are statistically significant.

### Wilcoxon rank sum tests for proliferative DR screening

- Run `script_wilk_tests_for_grouped_grades` to perform Wilcoxon rank sum tests and estimate if differences in the distributions between R0-2 and R3 grades are statistically significant.

### Plot bar charts with fractal dimensions as DR biomarkers

- Run `script_check_fractal_dimension_performance` to evaluate raw fractal dimensions as potential biomarkers for DR. This script reproduce Figure 6 from our paper.

### Plot bar charts with AUC values obtained with fractal measurements

- Run `script_check_fractal_measurement_performance` to train L1/L2 regularized logistic regression classifiers using fractal measurements for a given DR classification problem. If you setup the configuration file accordingly, it reproduces Figure 7.

### ROC curve for proliferative DR screening

- Run `script_train_kernelized_logistic_regression_classifier` to train L1/L2 regularized logistic regression classifiers using the fractal features that you want. At the end this will plot a ROC curve showing performance.


## Contributing

If you want to contribute to this project, please contact me by e-mail to [jiorlando -at- conicet.gov.ar](mailto:jiorlando@conicet.gov.ar)

## Authors

**José Ignacio Orlando** - *All coding* - [Github](https://github.com/ignaciorlando) - [Twitter](https://twitter.com/ignaciorlando)

See also the list of [contributors](https://github.com/ignaciorlando/fundus-fractal-analysis/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* This work is partially funded by ANPCyT PICT 2014-1730.
* J.I.O. and H.L.M. are funded by doctoral scholarships granted by CONICET.
* We would also like to thank NK and CFK. They know why :-)
