tableextension 50100 "Purchase&PayablesExt" extends "Purchases & Payables Setup"
{
    fields
    {
        field(52194423; "WorkflowTrial Two Nos."; Code[10])
        {
            Caption = 'WorkflowTrial Two Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}