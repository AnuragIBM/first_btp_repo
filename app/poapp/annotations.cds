using CatalogService as service from '../../srv/CatalogService';

annotate CatalogService.POs with @(
   // Common.DefaultValuesFunction : 'getOrderDefaults',
    //annotation to add selection field(filters)
UI.SelectionFields:[
        PO_ID,
        GROSS_AMOUNT,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY
    ],
   //to add cols
 UI.LineItem:[
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.BP_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : OVERALL_STATUS,
            Criticality: criticality,
            CriticalityRepresentation : #WithoutIcon,
        },
        //add actions to ui
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.boost',
            Label : 'Boost',
            Inline: true
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
    ],
        UI.HeaderInfo:{
        TypeName : 'PO',
        TypeNamePlural: 'POs',
        Title : {
            //the "$Type" property defines the type of UI element that should be rendered 
            //"UI.DataField" specifies that the field should be treated as a data field — 
            //a basic field that shows a value from the underlying data source.
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        Description: {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        ImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/IBM_logo.svg/2560px-IBM_logo.svg.png'
    },
     UI.Facets:[
        {
            //grup facet
            $Type : 'UI.CollectionFacet',
            Label : 'PO Details',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'identification',
                    Target : '@UI.Identification',

                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'More Info(field grp)',
                    Target : '@UI.FieldGroup#MoreInfo',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Pricing Details(field grp)',
                    Target : '@UI.FieldGroup#Spiderman',
                },
            ],
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'PO Line Items',
            //targeted at poitems annotation
            Target : 'Items/@UI.LineItem',
        },
    ],
    
UI.Identification:[
{
    //fields inside identification
$Type: 'UI.DataField', 
Value: PO_ID,
},
{
$Type: 'UI.DataField',
Value:PARTNER_GUID_NODE_KEY,
},
{
$Type: 'UI.DataField', 
Value: OVERALL_STATUS,
},
{
        $Type         : 'UI.DataFieldForAction',
        Label         : 'Set to Delivered',
        Action        : 'CatalogService.setOrderProcessing'
}
],

//field grup
     UI.FieldGroup #MoreInfo: {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : PO_ID,
            },
            {
                $Type : 'UI.DataField',
                Value : PARTNER_GUID_NODE_KEY,
            },
            {
                $Type : 'UI.DataField',
                Value : OVERALL_STATUS,
            }
        ],
    },
    UI.FieldGroup #Spiderman:{
        Data : [
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },{
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },{
                $Type : 'UI.DataField',
                Value : CURRENCY_code,
            },
        ],
    }    

);

//used to improve ui experience
annotate CatalogService.POs with {
    PARTNER_GUID@(
        //Instead of showing technical IDs like 123e4567-e89b-12d3-a456-426614174000, 
        //the UI will display company names like "SAP SE".
        //helps in user readibilty as they may not have knowledge of ids
        Common : { 
            Text : PARTNER_GUID.COMPANY_NAME,
         },
         //use value help here
         ValueList.entity: CatalogService.BusinessPartnerSet
    )
};
annotate CatalogService.POItems with {
    PRODUCT_GUID@(
        Common : { 
            Text : PRODUCT_GUID.DESCRIPTION,
         },
         ValueList.entity: CatalogService.ProductSet
    )
};

@cds.odata.valuelist//This marks BusinessPartnerSet as a Value Help Entity (F4 help).
//It means BusinessPartnerSet will be used as a search help (dropdown list)
annotate CatalogService.BusinessPartnerSet with @(
    //when used in dropdown company name value will show
    UI.Identification:[{
        $Type : 'UI.DataField',
        Value : COMPANY_NAME,
    }]
);

@cds.odata.valuelist
annotate CatalogService.ProductSet with @(
    UI.Identification:[{
        $Type : 'UI.DataField',
        Value : DESCRIPTION,
    }]
);

annotate CatalogService.POItems with @(
    UI.LineItem:[
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },{
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },{
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },{
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },{
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },{
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        }

    ],
    UI.HeaderInfo:{
        TypeName : 'PO Item',
        TypeNamePlural : 'PO Items',
        Title : {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.DESCRIPTION,
        }
    },
     UI.Facets:[
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Item Details',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Item Data',
                    Target : '@UI.FieldGroup#ItemData',
                },{
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Product Data',
                    Target : '@UI.FieldGroup#ProductData',
                }
            ],
        },
    ],
    UI.FieldGroup #ItemData:{
        Label : 'Item Data',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : PO_ITEM_POS,
            },{
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID_NODE_KEY,
            },{
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },{
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },{
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },{
                $Type : 'UI.DataField',
                Value : CURRENCY_code,
            },
        ],
    },
    UI.FieldGroup #ProductData:{
        Label: 'Product Details',
        Data: [
            {
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.CATEGORY,
            },{
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.DESCRIPTION,
            },{
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.PRICE,
            },{
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.SUPPLIER_GUID.ADDRESS_GUID.COUNTRY,
            },{
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.SUPPLIER_GUID.COMPANY_NAME,
            }
        ]
    }


    

);