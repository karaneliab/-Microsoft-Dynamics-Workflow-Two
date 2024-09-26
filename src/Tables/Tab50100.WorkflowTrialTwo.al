table 50100 "Workflow Trial Two"
{
    Caption = 'Workflow Trial Two';
    DataClassification = ToBeClassified;
    DrillDownPageId = "WorkflowTrialTwo Header";
    LookupPageId = "WorkflowTrialTwo Header";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." THEN begin
                    PurchSetup.Get();
                    PurchSetup.TestField("WorkflowTrial Two Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3; Status; Enum "Status Approval Enum")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(5; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No." = '' then
            PurchSetup.Get();
        PurchSetup.TestField("WorkflowTrial Two Nos.");
        NoSeriesMgt.InitSeries(PurchSetup."WorkflowTrial Two Nos.", xRec."No. Series", 0D, "No.", "No. Series");
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

}
