# ShopEasy App (95% Completed)
## Flutter App made by Team MATRIX using Firebase for CodeCamp 1.0

![shopEasy](https://github.com/sarthak290/test/blob/master/lo2.PNG)

### Please read all the [installation instruction](https://github.com/sarthak290/ShopEasy#installation-instruction) carefully before installing the app on your device

## About ShopEasy App

ShopEasy is an mobile application which is based on Flutter framerwork, made by Google. With the ambition of providing a platform to help the people of our country, ShopEasy gives a complete solution for optimizing your business with high productivity and cost-efficiency. It will give all the users ability to satisfy their business requirements which involves e-commerce functionality, attractive UI design and smooth performance. The app is supported on both Android and ios devices.

ShopEasy is made for following people and businesses:

 - Business people with growth ambition.
 - Small scale businesses limited to small cities and towns.
 - Businesses effected by COVID-19.
 - New comers who are starting their business from home due to being financially effected by COVID-19.
 - People who can't reach the shops to buy products.

Our aim is to spread awareness about locally popular brands and products so that they can attract customers out of their localities and cities. In this way our App ShopEasy promotes our Prime Minister's Atma Nirbhar Bharat campaign by providing small businesses and self-employed workers from any part of the country a platform for their business growth. This will encourage Atma-Nirbhar(Self-independent) nature among people of India, which will lead us to better a future.



## Features of ShopEasy App

- Easy and simple to use
- Sign In and Sign Up using Email
- Sign In using Facebook
- Sign In using Google
- Phone authentication by flutter firebase (Test: +911234567890, CODE: 333333)
- Clean and Well documented code
- Used Bloc pattern
- Custom Carousel Slider
- Form Validation
- Admin dashboard
- Complete e-commerce features – Dynamic Product variants, checkout process, order tracking, wishlist, manage address.
- Attractive UX design multi-level categories, quick product filter, super fast checkout flow.
- Powerful User Setting – the ability to enable the push notification, view wishlist, order history.
- Push notification
- Fast loading of images with Offline Image Caching
- Realtime
- 60 fps app
- Supports both Android and Ios devices.


## Installation Instruction

Apk file will be released for the app. Users can download the app on both Android and ios devices.
 - Make sure that there is minimum 800 MB space free in your device Internal memory.
 - There are two types of role assigned in the app:
   - user
   - admin
 - Only admins can use the Admin features like Add Product, Add category ,Add Brand etc.
 - To test the app as a admin login with following details:
   - email: email@email.com
   - password: ssssssss1
 - To test the app as a user login with any of the login methods like facebook, google etc.
 - Any new individual user who wants to be an admin of the app has to send a mail to [support](mailto:sarthaksbi@gmail.com) requesting admin permissions mentioning all the user details.
 - Our team will respond to your request within no time.


To setup the app code in your system , you should have flutter installed in your system if not then install [flutter](https://flutter.dev/docs/get-started/install).

Open the code on either Android Studio or VsCode with flutter support already installed and download the required dependencies of the app.


### Setup Firebase for the app

- Create a firebase project

- iOS

  - Create an iOS app in the firebase console.
  - Download the Googleservice-info.plist file
  - Replace the file in "ios/Runner"

- Android
  - Create an Android app in the firebase console.
  - Download the google-services.json file
  - Replace the file in "android/app"

Run the project.

- Don't forget to enable email and Gmail authentication and enable firestore database.

### Setup Facebook Login

- Create a [facebook app](https://developer.facebook.com)
- Enable facebook authentication in firebase
- Don't forget to enable email and Gmail authentication.
- Follow the facebook installation process on their website.
- Change the facebook app id in Android-manifest.xml and info.plist

### Setup Google Login

- Create a [google app](https://developers.google.com)
- Enable Google authentication in firebase
- Enter sha-1 and sha-256 certificates in firebase setting of the app.
- To find sha-1 certificate key for your app please refer this stackoverflow [answer](https://stackoverflow.com/questions/51845559/generate-sha-1-for-flutter-app)

### Firebase functions code.

- You need to install firebase cli on your system. Follow - https://firebase.google.com/docs/cli

#### 1. Change the project name

open .firebaserc file in the Firebase Functions folder

```
{
  "projects": {
    "default": "<enter-your-project-id>"
  }
}
```
> Project id is available from firebase console. 

#### 2. Deploy the firebase functions code

`firebase deploy --only functions`


## Operating Instructions 

One has to follow these steps to use ShopEasy app and get familier with it:
 
 - Install the apk of ShopEasy App. Make sure sufficient space is available in your phone internal memory.
 - Basic features will be shown on first use of the app.
 - Login to the ShopEasy App by any of the Login methods.
 - Login methods provided are:
   - Facebook Login
   - Google Login
   - Login with email and password
   - Phone authentication
 - You can now see the products on home screen. 
 - See trending and featured products.
 - You can also add them in your wishlist or if you want to buy them just add them to your cart.
 - To buy the product just go to your cart and confirm the address details and select payment methods.
 - To complete the purchase just click on confirm and your order will be placed.

 - To become a admin of the app i.e. to sell your products on the app and to setup the app according to your way, the business owner will have to send a request to grant admin permissions via mail to the [support](https://mail.google.com/) email given below.
 - On receiving the request our team will make you admin within no time.
 - Once you are admin you can open the side Navigation Drawer to view the admin features.
 - Admin can add products, add categories, add brands, add image sliders, view the list of orders received and can also see the list of users in the users panel.
 - One can also change the theme of the app in the settings panel.
 - Available themes:
   - Light
   - Dark

 ## File manifest

 This app code contains following files to make this code run.

 - Android folder (include all files to make the app run on android)
 - assets folder (include all the asset files like icon,images,fonts required in the app)
 - gen folder (automatically generated by flutter)
 - ios folder (include all files to make the app run on ios)
 - lib folder (include all the dart code files)
 - pubspec.yaml file (include all the dependencies and declaration of other asset required in thr spp)
 - README.md file (complete documentation of ShopEasy App)

## Known bugs

 - Login screen might not render properly on some devices because every device has different resolution. Device with small screen size may have this bug.
 - No Online Payment gateway has been added till now. Currently you can only order through Cash on delievery. Online payment gateways will be added in further releases.


## Troubleshooting

For any kind of Support and help please contact via mail given below.

Support mail: [sarthaksbi@gmail.com](mailto:sarthaksbi@gmail.com)

