//good practise to store the reusables in seperate file(commons.cds) and then import it like this
using { ibmcap.common } from './commons';//custom aspects
using { managed, temporal, Country,cuid } from '@sap/cds/common';//standard aspects,already present
// aspect temporal {
//   validFrom : Timestamp @cds.valid.from;
//   validTo   : Timestamp @cds.valid.to;
// }
// aspect managed {
//   createdAt  : Timestamp @cds.on.insert : $now;
//   createdBy  : User      @cds.on.insert : $user;
//   modifiedAt : Timestamp @cds.on.insert : $now  @cds.on.update : $now;
//   modifiedBy : User      @cds.on.insert : $user @cds.on.update : $user;
// }
//Country has country codes
//cuid automatically adds primary keys

namespace ibmcap.db;

//context gives desc of the data we are storing
//like master data
context master{

//only make changes here to enhance keys
//type Guid:Int16;

//seperate tables as an entity

entity temp : cuid {
       //here we are not adding primary key col cause we attached cuid to temp and cuid automatically
       //does that for us
       name:String(30);
}

//so instead of making cols for all entities, we can just attach the aspect to the entity and cols will
//automatically be added(just like for student col validfrom and validto)
       entity student: temporal {
        //before . will come what is after ibmcap. in namespace
             key studentId: common.Guid;//primary key
             name:String(30);
             class: Association to stu_class;//primary key-foreign key relationship
             //class: Association to one stu_class
             //class: Association to many stu_class, can specify the cardianility
             parent: String(60); 
             joiningDate: Date;
             country: Country;
        
       }
       entity stu_class: managed{
        key classId: common.Guid;
        name: String(30);
        section: String(15);
       }



}