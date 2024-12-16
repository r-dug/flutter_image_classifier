# flutter_image_classifier

This project was inspired by the use of the mobile application Picture Mushroom while I was in the woods, out of cell range. Once upon a time, I didn't have an internet connection. I was trying to identify some species of mushroom. Alas, there is no "offline" mode for Picture Mushroom. They want your data to train their models. I get it... I do too (because I can't monetize this with iNaturalist's data)! HOWEVER, an Idea was born... Well... a question, really. "Can a classification architecture like MobileNet do a reasonably good job identifying species of mushrooms?" So, here we are, building it... or... at least giving it the ol' college try  

## Getting started

### Download and Installation

Feel free to clone this repo, build an APK and run inferences on your mobile device! Go for it! I'll add a lil link to the app store if I ever release it though. It'll be free as well, because I cannot monetize this app with a model trained on iNaturalist's open-source data.

## Tech Stack

<a href="https://flutter.dev/">
  <img src="https://juststickers.in/wp-content/uploads/2019/01/flutter.png" alt="flutter" width="75" height="75">
</a>

### Flutter

I chose flutter to develop this application for its platform agnosti approach, Currently I have only been focussing on the Androi implementation.. but in hindsight it would have been well-advised to work on IoS implementation at the same time. Now, I'll have to retroactively work on IoS configurations for steps that would have been easier to knock out while I was working on the Android configs. Live and learn.

#### Deps

- **tf_lite_flutter**

Flutter has packages for using tensorflow lite, albeit there are multiple; they are of varied effectiveness and bugginess. It appears that Flutter development by the Tensorflow team has been fairly stagnant as of late. Some migrations have taken place from deprecated packages, and they have not been maintained to the newer versions of tensorflow. Consequently, the C bindings to tensorflow OPS are of incompatible versioning. I ended up needing to clone the offending repository and update it so that my model could run, which took FAR longer to realize than it did to actually fix. Furthermore, the documentation was not always that excellent... adequate? maybe. excellent? not in my opinion. Nonetheless, the package does implement very effective tooling for interacting with models, and running inference locally... So I'm still a fan.  

- **image**

For handling image data on the mobile device (for example, converting the raw image data into a matrix of numericals representative of RGB values which could be fed into the model).

- **image_picker**

Enables a user to upload images from their device (gallery, not camera)

- **image_picker_platform_interface**

Platform specific helper for the image_picker dep. 

- **camera**

Self explanatory. Provides interaction with the device's camera.

- **path**

Dealing with paths... come on, guys.

- **path_provider**

MMMM.... yeah. Read the docs, if you like.

<a href="https://www.python.org/">
  <img src="https://www.moosoft.com/wp-content/uploads/2021/07/Python.png" alt="HTML" width="75" height="75">
</a>

<a href="https://www.tensorflow.org/">
  <img src="https://miro.medium.com/v2/resize:fit:256/1*cKG1LJvVTaWqSkYSyVqtsQ.png" alt="Tensorflow" width="75" height="75">
</a>

## Image Classification Model

The model training is addressed in this [repository](https://github.com/r-dug/Mushroom_Classifier). I won't go into great detail in this README but instead outline the critical components. For more detailed explanations, visit the aforementioned repo.

### Architecture

Currently, I am using an adaption of the MobileNetV3Large architecture, based off of the application from Tensorflow.

### Performance

Performance of the tflite model is of interest here. Testing still must be done.

### Training

The most difficult part was curating a high quality dataset. Big "Thank You!" to iNaturalist for opensourcing their data.

### Conversion: tf -> tflite 

Tensorflow really makes it easy to convert a tensorflow or keras model into its 'lite' version. They even have quantization options, though they are a bit more tedious and require a representative dataset. Quantization might be interesting to experiment with because it can decrease the effective expense of storing the model (size) and running inference (compute). There is, however, a tradeoff in model performance; but it might be worth while using a model architecture that offers better performance. The question would remain whether the quantization step decreases model size enough, and whether the quantized model still outperforms (and if so, to what degree).
