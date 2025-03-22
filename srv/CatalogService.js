//cds.service.impl is a CAPM framework function used to define custom logic for a CDS service.
//It registers the logic that runs when the service is initialized.

module.exports = cds.service.impl( async function(){

    //Step 1: get the object of our odata entities
    const { EmployeeSet, POs } = this.entities;

    //Step 2: define generic handler for validation
    //before updating employeeset do this
    this.before('UPDATE', EmployeeSet, (req,res) => {
        console.log("Aa gaya " + req.data.salaryAmount);
        if(parseFloat(req.data.salaryAmount) >= 1000000){
            //in capm req.error is used instead of res.error to throw an error
            //better practise use 400 instead of 500 for input validation errors
            req.error(500, "Salary must be less than a million for employee");
        }
    });

    this.on('getOrderDefaults', async (req,res)=>
    {
        return {Status: 'N'};
    });
    //this.on() → Registers a handler for the "boost" action.
    this.on('boost', async (req,res) => {
        try {
            //req.params → Captures parameters from the request URL or path.
            //req.params[0] → The first parameter in the request (e.g., ID of the record).
            //POST /odata/v4/POService/boost('12345')
                  //Here, 12345 is passed as req.params[0].
            const ID = req.params[0];
            console.log("Hey Amigo, Your purchase order with id " + req.params[0] + " will be boosted");
            const tx = cds.tx(req);//cds.tx(req) → Starts a new database transaction for the current request
            await tx.update(POs).with({
                GROSS_AMOUNT: { '+=' : 20000 },
                NOTE: 'Boosted!!'
            }).where(ID);//.where(ID) → Filters the row based on the provided ID.
        } catch (error) {
            return "Error " + error.toString();
        }
    });
    this.on('setOrderProcessing', POs, async (req,res) => {
        const tx = cds.tx(req);
        await tx.update(POs).set({Status: 'Delivered'}).where({ID:req.params[0]});
    });


    this.on('largestOrder', async (req,res) => {
        try {
            const ID = req.params[0];
            const tx = cds.tx(req);
            
            //SELECT * UPTO 1 ROW FROM dbtab ORDER BY GROSS_AMOUNT desc
            const reply = await tx.read(POs).orderBy({
                GROSS_AMOUNT: 'desc'
            }).limit(1);

            return reply;
        } catch (error) {
            return "Error " + error.toString();
        }
    });

}
);