codeunit 50102 WorkflowResponses
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnOpenDocument, '',false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef;var Handled: Boolean)
    var
     WorkflowTrial: Record "Workflow Trial Two"; 
     

    begin
        VarVariant := RecRef;
        case RecRef.Number of
            Database::"Workflow Trial Two":
                begin
                    // RecRef.SetTable(WorkflowTrial);
                    // WorkflowTrial.Validate(Status,WorkflowTrial.Status::Open);
                    // WorkflowTrial.Modify(true);
                    WorkflowTrial.SetView(RecRef.GetView());
                    Handled := true;
                    WorkflowTrial.Validate(Status,WorkflowTrial.Status::Open);
                    WorkflowTrial.Modify(TRUE);

                    
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef;var Handled: Boolean)
    var
        WorkflowTrial: Record "Workflow Trial Two"; 
    begin 
       case  RecRef.Number of
       Database::"Workflow Trial Two":
           begin
            RecRef.SetTable(WorkflowTrial);
            WorkflowTrial.Validate(Status,WorkflowTrial.Status::Approved);
            WorkflowTrial.Modify(true);
            Handled := true;

           end;

       end;
        
    end;
}
