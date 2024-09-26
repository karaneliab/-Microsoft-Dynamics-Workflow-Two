codeunit 50100 workfflowEventHandling
{

    procedure RunWorkflowOnSendForApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendForApproval'));
    end;

    procedure RunWorkflowOnCancelApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelApprovalRequest'));
    end;
   

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval workflow Trial", OnSendWorkflowForApproval, '', false, false)]
    procedure RunWorkflowOnSendForApproval(var WorkflowTrial: Record "Workflow Trial Two")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendForApprovalRequestCode(), WorkflowTrial);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval workflow Trial", OnCancelWorkflowForApproval, '', false, false)]
    procedure RunWorkflowOnCancelApprovalRequest(var WorkflowTrial: Record "Workflow Trial Two")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelApprovalRequestCode, WorkflowTrial);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", OnAddWorkflowEventsToLibrary, '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        workflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowTrial: Record "Workflow Trial Two";
    begin
        workflowEventHandling.AddEventToLibrary(RunWorkflowOnSendForApprovalRequestCode(), Database::"Workflow Trial Two", WorkflowSendForApprovalEventDescTxt, 0, false);
        workflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelApprovalRequestCode(), Database::"Workflow Trial Two", WorkflowCancelForApprovalEventDescTxt, 0, FALSE);


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    var
        workflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowTrial: Record "Workflow Trial Two";
    begin
        case EventFunctionName of
            RunWorkflowOnCancelApprovalRequestCode():
                workflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelApprovalRequestCode, RunWorkflowOnSendForApprovalRequestCode);
            RunWorkflowOnSendForApprovalRequestCode():
                workflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelApprovalRequestCode, RunWorkflowOnSendForApprovalRequestCode);

        END;
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowSendForApprovalEventDescTxt: Label 'Approval for %1 is XXXXXXXXXXXX requested.';
        WorkflowCancelForApprovalEventDescTxt: Label 'Approval for  %2  is YYYYYYYYYYYYYYY cancelled.';

}
