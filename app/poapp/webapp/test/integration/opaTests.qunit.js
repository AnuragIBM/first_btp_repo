sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'com/po/poapp/test/integration/FirstJourney',
		'com/po/poapp/test/integration/pages/POsList',
		'com/po/poapp/test/integration/pages/POsObjectPage',
		'com/po/poapp/test/integration/pages/POItemsObjectPage'
    ],
    function(JourneyRunner, opaJourney, POsList, POsObjectPage, POItemsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('com/po/poapp') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onThePOsList: POsList,
					onThePOsObjectPage: POsObjectPage,
					onThePOItemsObjectPage: POItemsObjectPage
                }
            },
            opaJourney.run
        );
    }
);