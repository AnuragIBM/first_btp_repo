using { anubhav.db.master, anubhav.db.transaction } from '../db/datamodel1';

//definition
//capm sees ucase letters as break so to have MyService as path we use this attribute
service MyService @(path:'MyService') {
    //hello(name='s') is the way to test
function hello (name: String) returns String;

    @readonly//we tell the framework its readonly
    entity ReadEmployeeSrv as projection on master.employees;
    @insertonly
    entity InserEmployeeSrv as projection on master.employees;
    @updateonly
    entity UpdateEmployeeSrv as projection on master.employees;
    @deleteonly
    entity DeleteEmployeeSrv as projection on master.employees;
}