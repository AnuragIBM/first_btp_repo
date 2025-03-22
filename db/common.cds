namespace anubhav.common;
using { Currency } from '@sap/cds/common';

//In TypeScript, an enum is a way to define a set of named constants. 
//The code you've shared is intended to create an enum for representing gender, with three possible values: male, female, and undisclosed.
type Gender : String(1) enum{
    male = 'M';
    female = 'F';
    undisclosed = 'U';
};

//the @ symbol is used to define annotations. Annotations are metadata or additional 
//descriptive information that can be applied to various elements in your data model, such as fields, types, and entities.
type AmountT : Decimal(10,2)@(
    Semantics.amount.currencyCode: 'CURRENCY_CODE',
    //Semantics.amount.currencyCode is a standard annotation 
    //in CDS to indicate that this data type represents an amount and is associated with a currency code.
//The annotation tells SAP tools and applications that the AmountT type is linked to a currency code (like "USD" for US dollars, "EUR" for euros, etc.).
    sap.unit:'CURRENCY_CODE'
    //sap.unit: This is a semantic annotation used to indicate the unit of measure for the data field. 
    //In the context of SAP, it’s typically used to specify the unit of a measure
);

aspect Amount: {
    CURRENCY: Currency;
    GROSS_AMOUNT: AmountT @(title : '{i18n>GrossAmount}');
    //'{i18n>GrossAmount}' is a reference to an i18n (internationalization) label, meaning the title 
    //"Gross Amount" will be displayed to the user in their preferred language, based on the i18n file/resource.
    NET_AMOUNT: AmountT @(title : '{i18n>NetAmount}');
    TAX_AMOUNT: AmountT @(title : '{i18n>TaxAmount}');
    //similar for net and tax amt
}


type Guid: String(32);
//The @assert.format annotation ensures that any value assigned to a PhoneNumber field follows the pattern defined by the regular expression.
type PhoneNumber: String(30)@assert.format : '^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
type Email: String(255)@assert.format : '^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$';