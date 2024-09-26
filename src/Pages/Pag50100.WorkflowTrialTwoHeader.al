page 50100 "WorkflowTrialTwo Header"
{
    ApplicationArea = All;
    Caption = 'WorkflowTrialTwo Header';
    PageType = Card;
    SourceTable = "Workflow Trial Two";
    PromotedActionCategories = 'Approval';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action("SendApprovalRequest")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Send Approval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    ToolTip = 'Send an approval request with the specified settings.', Comment = '%';
                    Promoted = true;
                    PromotedCategory = Process;
                    // Visible = true;
                    trigger OnAction()
                    Var
                        AppWorkflows: Codeunit "Approval workflow Trial";
                        WorkflowTrial: Record "Workflow Trial Two";
                        EventHandling: Codeunit workfflowEventHandling;
                    begin

                        // if AppWorkflows.CheckApprovalsWorkflowEnabled(WorkflowTrial) then
                        //     AppWorkflows.OnSendWorkflowForApproval(WorkflowTrial);
                        //   WorkflowTrial.Get();
                        if AppWorkflows.CheckApprovalsWorkflowEnabled(WorkflowTrial) then
                           AppWorkflows.OnSendWorkflowForApproval(WorkflowTrial);

                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Approval Request';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    ToolTip = 'Cancel Approval Request';
                    PromotedCategory = Process;
                    // Visible = true;
                    trigger OnAction()
                    Var
                        AppWorkflows: Codeunit "Approval workflow Trial";
                        WorkflowTrial: Record "Workflow Trial Two";
                    begin

                        AppWorkflows.OnCancelWorkflowForApproval(WorkflowTrial);
                    end;
                }
            }
        }
        area(Creation)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.';
                    Promoted = true;
                    PromotedCategory = New;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    begin
                        // !Approve the document
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the Approval Requests.';
                    Promoted = true;
                    PromotedCategory = New;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    trigger OnAction()
                    begin
                        // !Reject the document
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                        ;

                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the Approval Request to another user.';
                    Promoted = true;
                    PromotedCategory = New;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    trigger OnAction()
                    begin
                        // !Delegate the document
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';
                    Promoted = true;
                    PromotedCategory = New;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    trigger OnAction()
                    begin
                        // !Open the comments page
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;


                }
                action(Approvals)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View approval requests.';
                    Promoted = true;
                    PromotedCategory = New;
                    Visible = HasApprovalEntries;
                    trigger OnAction()
                    begin
                        // !Open the approvals page
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        // ?Set the approval status to pending
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        HasApprovalEntries := ApprovalsMgmt.HasApprovalEntries(Rec.RecordId)


    end;

    var
        OpenApprovalEntriesExistCurrUser, OpenApprovalEntriesExist, CanCancelApprovalForRecord, HasApprovalEntries : Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
}
