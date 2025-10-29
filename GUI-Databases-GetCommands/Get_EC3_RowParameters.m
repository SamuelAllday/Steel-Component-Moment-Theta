function [Row_Parameters_CF, Row_Parameters_EP]=Get_EC3_RowParameters()

load('temp.mat');

Individual=1;
    
for i=1:nrow

    if ConType=='FEP'
        
        ExteriorRow=0;

        if i==1 || i==nrow
           EndRow=0;
           if i==1;     EndRowLoc=1; end
           if i==nrow;  EndRowLoc=3; end
           Next2Flange=1;
           if StiffenerC=="Both";               Next2Stiffener=1; end
           if StiffenerC=="No";                 Next2Stiffener=0; end
           if StiffenerC=="Comp" && i==1;       Next2Stiffener=0; end
           if StiffenerC=="Comp" && i==nrow;    Next2Stiffener=1; end
        else
           EndRow=0;
           EndRowLoc=2;
           if i==nTrow;  EndRowLoc=3; end
           Next2Flange=0;        
           Next2Stiffener=0;
        end
    
        pavg = p;

    elseif ConType=="EEP"
        
        pavg = (pt+p)/2;

%         if i==1 && SingleRowEx=="Yes"; p=pt; end
        
        if i==1 || (i==2 && SingleRowEx=="No") || (i==nrow && Extension=="Double") 
            ExteriorRow=1;
        else
            ExteriorRow=0;            
        end
        
        if (i==1 && SingleRowEx=="Yes") || (i==2 && SingleRowEx=="Yes") || (i==nrow-1 && Extension=="Double") || (i==nrow && Extension=="Single")
           EndRow=0;
            Next2Flange=1;
           if StiffenerC=="Both";               Next2Stiffener=1; end
           if StiffenerC=="No";                 Next2Stiffener=0; end
           if StiffenerC=="Comp" && i==1;       Next2Stiffener=0; end
           if StiffenerC=="Comp" && i==nrow;    Next2Stiffener=1; end
        else
           EndRow=0;
           EndRowLoc=2;
           Next2Flange=0;        
           Next2Stiffener=0;
        end
        
        if     i==1;      EndRowLoc=1; 
        elseif i==nTrow;  EndRowLoc=3; 
        else              EndRowLoc=2; 
        end
           
    end

    Row_Parameters_CF(i,:)=[Individual   EndRow   EndRowLoc  StiffenedC   Next2Stiffener m_cf  m_2        e_cf  e1(i) p pavg];
    Row_Parameters_EP(i,:)=[Individual   EndRow   EndRowLoc  ExteriorRow  Next2Flange    m_ep  m_2   m_x  e_ep  e_x   p pavg g bep bolt4_m1 bolt4_e1 bolt4_e2];
end




