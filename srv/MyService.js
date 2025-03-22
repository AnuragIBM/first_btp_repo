//implementation
//we register our module,then we get cds object on which we call our event

module.exports = (cds) => {
    cds.on('hello', req => {
        return 'hey amigo welcome to my world, your name is' + req.data.name;
    });
    
    
    const { employees } = cds.entities("anubhav.db.master");
    cds.on("READ", "ReadEmployeeSrv", async(req,res) => {

        var results = [];

        //Example 1: hardcoded data
        // results.push({
        //     "ID":"02BD2137-0890-1EEA-A6C2-VV55C19787CD",
        //     "nameFirst": "Chistiano",
        //     "nameLast": "Ronaldo"
        // });


        //Example 2: Use Select on DB table
        //results = await cds.tx(req).run(SELECT.from(employees).limit(10));

        //Example 3: Use Select on DB table with where
        //results = await cds.tx(req).run(SELECT.from(employees).limit(10).where({"nameFirst":"Susan"}));

        //Example 4:Caller will pass the condition like ID
        //use /Entity/key
        var whereCondition = req.data;
        console.log(whereCondition);
        if(whereCondition.hasOwnProperty("ID")){
            results = await cds.tx(req).run(SELECT.from(employees).limit(10).where(whereCondition));
        }else{
            results = await cds.tx(req).run(SELECT.from(employees).limit(5));
        }


        return results;


    });
}