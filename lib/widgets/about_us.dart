import 'package:flutter/material.dart';
import 'package:matrix/utils/config.dart';

class AboutUs extends StatefulWidget {
  bool ishelp;
  
  AboutUs(
      {Key key,
      this.ishelp})
      : super(key: key);
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    const logoConfig = Logo;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ishelp?"Help/Support":
          "About ShopEasy",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 0.5,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Center(
                  child: Container(
                    child: !logoConfig["isImage"]
                        ? Text(
                            logoConfig["title"],
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontFamily: logoConfig["fontFamily"],
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.73,
                              fontSize: logoConfig["fontSize"],
                            ),
                          )
                        : logoConfig["isAsset"]
                            ? Image.asset(logoConfig["image"])
                            : Image.network(logoConfig["image"]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 0.5,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(widget.ishelp?"For any issue and query please contact us on support contact given below. \n\n Email at: sarthaksbi@gmail.com \n Phone No.: 1234567890":
                  "ShopEasy is an mobile application which is based on Flutter framerwork, made by Google. With the "
                  "ambition of providing a platform to help the people of our country, ShopEasy gives a complete "
                  "solution for optimizing your business with high productivity and cost-efficiency. It will give all "
                  "the users ability to satisfy their business requirements which involves e-commerce functionality, "
                  "attractive UI design and smooth performance. The app is supported on both Android and ios devices."
                  "\n\n\nOur aim is to spread awareness about locally popular brands and products so that they can "
                  "attract customers out of their localities and cities. In this way our App ShopEasy promotes our "
                  "Prime Minister's Atma Nirbhar Bharat campaign by providing small businesses and self-employed "
                  "workers from any part of the country a platform for their business growth. This will encourage "
                  "Atma-Nirbhar(Self-independent) nature among people of India, which will lead us to better a future.",
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
