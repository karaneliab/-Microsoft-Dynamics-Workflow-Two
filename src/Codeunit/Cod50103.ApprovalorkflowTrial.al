codeunit 50103 "Approval workflow Trial"
{
    procedure CheckApprovalsWorkflowEnabled(var WorkflowTrial: Record "Workflow Trial Two"): Boolean
    begin
        if NOT IsWorkflowEnabled(WorkflowTrial) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;


    procedure IsWorkflowEnabled(VAR WorkflowTrial: Record "Workflow Trial Two"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(WorkflowTrial, WorkflowEventHandling.RunWorkflowOnSendForApprovalRequestCode));
    end;


    [IntegrationEvent(false, false)]
    procedure OnSendWorkflowForApproval(VAR WorkflowTrial: Record "Workflow Trial Two")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelWorkflowForApproval(VAR WorkflowTrial: Record "Workflow Trial Two")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnSetStatusToPendingApproval, '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef;var Variant: Variant;var IsHandled: Boolean)
     Var
            WorkflowTrial : Record "Workflow Trial Two";
          
    begin
       case RecRef.Number of
           Database::"Workflow Trial Two":
           begin
            RecRef.SetTable(WorkflowTrial);
            WorkflowTrial.Validate(Status,WorkflowTrial.Status::Pending);
            IsHandled := true;
            Variant := true;
           end;
       
       end;    
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnPopulateApprovalEntryArgument, '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var ApprovalEntryArgument: Record "Approval Entry"; var RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowTrial: Record "Workflow Trial Two";
    begin
        case RecRef.Number of
            Database::"Workflow Trial Two":
                begin
                    RecRef.SetTable(WorkflowTrial);
                    ApprovalEntryArgument."Document No." := WorkflowTrial."No.";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnRejectApprovalRequest, '', false,false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        WorkflowTrial: Record "Workflow Trial Two";
         RecRef: RecordRef;
    begin
        RecRef.Get( ApprovalEntry."Record ID to Approve");
        case
            RecRef.Number of
            Database::"Workflow Trial Two":
            begin
                RecRef.SetTable(WorkflowTrial);
                    if WorkflowTrial.Get(ApprovalEntry."Document No.") then begin
                        WorkflowTrial.validate(Status,WorkflowTrial.Status::Rejected);
                        WorkflowTrial.Modify(true);
                    end;
            end;
        end;
        
    end;



    var
        WorkFlowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit workfflowEventHandling;
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
}
