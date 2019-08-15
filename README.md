# Barcode-Database-App

Prototype for SHAD -- Yttrium
<br/>
<br/>
### Database
##### Accessing all products:
`GET http://eatcofriendly.000webhostapp.com/api/product/read.php`

```
{
  "records":[
  {
    "barcode":"0062020000743",
    "product_name":"Nutella",
    "company_name":"Ferrero",
    "image":"https:\/\/www.cutpricebarrys.co.uk\/wp-content\/uploads\/2018\/10\/nutella.jpg",
    "recyclable":"1",
    "biodegradable":"0",
    "disposal":"Lid - recycling bin\r\nContainer - recycling bin\r\nFoil - recycling bin\r\n\r\n*make sure to clean off all residue before recycling",
    "points":"20",
    "suggestions":null
  },
  {
    "barcode":"0064100589988",
    "product_name":"Mini-Wheats",
    "company_name":"Kellogg's",
    "image":"https:\/\/az836796.vo.msecnd.net\/media\/image\/product\/en\/medium\/0006410058998.jpg",
    "recyclable":"1",
    "biodegradable":null,
    "disposal":"Box - recycling bin\r\nPlastic bag - garbage","points":"20","suggestions":null
  }]
}
```
(yes, there are only 2 products)

##### Accessing one product with the barcode:
`GET http://eatcofriendly.000webhostapp.com/api/product/read_one.php?barcode=0062020000743`

```
{
  "barcode":"0062020000743",
  "product_name":"Nutella",
  "company_name":"Ferrero",
  "image":"https:\/\/www.cutpricebarrys.co.uk\/wp-content\/uploads\/2018\/10\/nutella.jpg",
  "recyclable":"1",
  "biodegradable":"0",
  "disposal":"Lid - recycling bin\r\nContainer - recycling bin\r\nFoil - recycling bin\r\n\r\n*make sure to clean off all residue before recycling",
  "points":"20",
  "suggestions":null
}
```
(also, we hosted with 000webhost because we didn't want to spend any money)
<br/>
<br/>
### Helpful Links
* [Building a Simple Barcode Scanner in iOS](https://gkbrown.org/2016/11/11/building-a-simple-barcode-scanner-in-ios/)
* [How To Create A Simple REST API in PHP](https://www.codeofaninja.com/2017/02/create-simple-rest-api-in-php.html)
* [The Best Way to Connect Your iOS App to MySQL Database](https://codewithchris.com/iphone-app-connect-to-mysql-database/)
