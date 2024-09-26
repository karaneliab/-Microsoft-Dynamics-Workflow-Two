pageextension 50100 "Purchases&Payables" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Posted Invoice Nos.")
        {
            field("WorkflowTrial Two Nos."; Rec."WorkflowTrial Two Nos.")
            {
                ApplicationArea = All;

            }
        }
    }
}