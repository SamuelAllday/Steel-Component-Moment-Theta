function [figX]=plot_Connection(DB,ConType,SN)

clc;

tep=DB.tep(SN);
hep=DB.hep(SN);
bep=DB.bep(SN);

Column=DB.Column(SN);
hc=DB.hc(SN);
hb= DB.hb(SN);
bcf =DB.bcf(SN);
bbf =DB.bbf(SN);
tcf=DB.tcf(SN);

Beam=DB.Beam(SN);
tbf=DB.tbf(SN);
tcw=DB.tcw(SN);
tbw=DB.tbw(SN);

et=DB.et(SN);
ec=DB.ec(SN);
ert=DB.ert(SN);
erc=DB.erc(SN);
ecc=(bcf-bep)/2;
g= DB.g(SN);
db=DB.db(SN);
if ConType=="EEP"
    pc=DB.pc(SN); if isnan(pc); pc=0; end
    pt=DB.pt(SN); if isnan(pt); pt=0; end
else
    pc=DB.p(SN); if isnan(pc); pc=0; end
    pt=DB.p(SN); if isnan(pt); pt=0; end
end
pi=DB.pi(SN);
p   = DB.p(SN); if isnan(p); p=0; end

StiffenerC=DB.StiffenerC(SN);
tstiffC=DB.tstiffC(SN);
if ConType=="EEP"
    StiffenerP=DB.StiffenerP(SN);
    tstiffP=DB.tstiffP(SN);
    Extension=DB.Extension(SN);
else
    StiffenerP="No";
    tstiffP="NA";
    Extension="NA";
end
DP=DB.DP(SN);
CP=DB.CP(SN);
tcp=DB.tcp(SN);
DB.tcp(SN);
nTotal=DB.nTotal(SN);
db=DB.db(SN);
BoltSize=DB.BoltSize(SN);
GradeB=DB.GradeB(SN);
GradeC=DB.GradeC(SN);
GradeP=DB.GradeP(SN);
GradeBolt=DB.GradeBolt(SN);
SpecimenID=DB.ID(SN);
Slab=DB.Slab(SN);
hslab=DB.hslab(SN);
Wslab=DB.Wslab(SN);
Deck=DB.Deck(SN);
RibOrientation=DB.RibOrientation(SN);
hrib=DB.hrib(SN);
tdeck=DB.tdeck(SN);
Joint=DB.Joint(SN);
Axis=DB.Axis(SN);

BoltLayout_T=DB.BoltLayout_T(SN);
BoltLayout_C=DB.BoltLayout_C(SN);
if ConType=="EEP"; SingleRowEx   = DB.SingleRowEx(SN); else; SingleRowEx ='Yes'; end

nTrow  = BoltLayout_T;  nTrow  = char(nTrow);  nTrow  = str2double(nTrow(1)); nTcol  = char(BoltLayout_T); nTcol  = str2double(nTcol(end));
nCrow  = BoltLayout_C;  nCrow  = char(nCrow);  nCrow  = str2double(nCrow(1));

if Column=="Rigid"
    hc=  300;
    bcf= max([bbf bep]);
    tcf=50;
elseif Column=="NA"
    hc=  0;
    bcf=  0;
    tcf=0;
end

xcenterEV=0;
eccBeam=hep;

%% Plot

figX=figure('position',[700 100 350 300],'color','white');
hold on;
set(gca,'visible','off')
set(gca,'xtick',[])
set(gca,'ytick',[])
if Joint=="Splice"
    set(gca,'Xlim',[0 1.1*(hc+1.5*hb+bep)]);
else
    set(gca,'Xlim',[0 1.1*(hc+1.5*hb+bcf)]);
end
set(gca,'Ylim',[-2.0*hep 1.8*hep]);

% Column
if Joint=="Splice"
    
else
    if Axis=="Major"
        rectangle('Position',[xcenterEV,    -1.5*hep,  hc,         3*hep],'FaceColor','w','EdgeColor','k','LineWidth',0.5);
        if contains(Column,'SHS')==1
            rectangle('Position',[xcenterEV+tcf,-1.5*hep,  hc-2*tcf,   3*hep],'FaceColor','w','EdgeColor','k','LineStyle','--','LineWidth',0.5);
        else
            rectangle('Position',[xcenterEV+tcf,-1.5*hep,  hc-2*tcf,   3*hep],'FaceColor','w','EdgeColor','k','LineStyle','-','LineWidth',0.5);
        end
    else
        rectangle('Position',[xcenterEV+hc-bcf/2, -1.5*hep,  bcf,    3*hep],'FaceColor','w','EdgeColor','k','LineWidth',0.5);
        rectangle('Position',[xcenterEV+hc-tcw,   -1.5*hep,  tcw,    3*hep],'FaceColor',[0.7 0.7 0.7],'EdgeColor','k','LineWidth',0.5);
    end
end

% Doubler plate
if DP=="Yes"
    rectangle('Position',[xcenterEV-hc+tcf+tcw,-0.6*hep,  hc-2*tcf-2*tcw,   1.2*hep],'FaceColor',[0.8 0.8 0.8],'EdgeColor','k','LineStyle','-','LineWidth',0.5);
end

% Cover plate
% if CP=="Yes"
%     rectangle('Position',[xcenterEV+2*tep,-0.5*hb-tcp,0.5*hb,tcp],'FaceColor','w','EdgeColor','k','LineWidth',0.5);
%     rectangle('Position',[xcenterEV+2*tep, 0.5*hb    ,0.5*hb,tcp],'FaceColor','w','EdgeColor','k','LineWidth',0.5);
% end

% Column Stiffener
if StiffenerC=="Both"
    rectangle('Position',[xcenterEV+tcf,-0.5*hep+ec,    hc-2*tcf,tstiffC],'FaceColor',[0.65 0.65 0.65],'EdgeColor','k','LineWidth',0.5);
    rectangle('Position',[xcenterEV+tcf, 0.5*hep-et-tbf,hc-2*tcf,tstiffC],'FaceColor',[0.65 0.65 0.65],'EdgeColor','k','LineWidth',0.5);
elseif StiffenerC=="Comp"
    rectangle('Position',[xcenterEV+tcf,-0.5*hep+ec,    hc-2*tcf,tstiffC],'FaceColor',[0.65 0.65 0.65],'EdgeColor','k','LineWidth',0.5);
end

% End plate
rectangle('Position',[xcenterEV+hc,     -hep/2,  tep,        hep],  'FaceColor',[0.75 0.75 0.75],'EdgeColor','k','LineWidth',0.5);

% Beam
rectangle('Position',[xcenterEV+hc+tep,-0.5*hep+ec,    1*hb,hb],      'FaceColor','w','EdgeColor','k','LineWidth',0.5);
rectangle('Position',[xcenterEV+hc+tep,-0.5*hep+ec+tbf,1*hb,hb-2*tbf],'FaceColor','w','EdgeColor','k','LineWidth',0.5);
% text(xcenterEV+tep+0.25*hb,0.0,Beam,'Fontname','times','fontsize',8);

if Slab=="Yes"
    h=patch([xcenterEV+hc xcenterEV+hc xcenterEV+hc+tep+1*hb xcenterEV+hc+tep+1*hb],[hb/2  hb/2+hslab  hb/2+hslab  hb/2],[0.0 0.0 0.0]);
    hatchfill(h,'speckle',45,0.3,[0.85 0.85 0.85]);
    if Deck~="NA"
        if RibOrientation=="Parallel"
            patch([xcenterEV+hc xcenterEV+hc xcenterEV+hc+tep+1*hb xcenterEV+hc+tep+1*hb],[hb/2  hb/2+5*tdeck  hb/2+5*tdeck  hb/2],[0.0 0.0 0.0]);
        else
            %plot([xcenterEV+hc-tcf xcenterEV+hc+tep],[-0.5*hep+erc+(i-1)*pc -0.5*hep+erc+(i-1)*pc],'r','LineWidth',3)
        end
    end
end


% Bolt
for i=1:nTrow
    if SingleRowEx=="Yes"
        plot([xcenterEV+hc-tcf xcenterEV+hc+tep],[ 0.5*hep-ert-min(1,i-1)*pt-max(0,i-2)*p  0.5*hep-ert-min(1,i-1)*pt-max(0,i-2)*p],'Color',[0.0 0.60 0.0],'LineWidth',3)
    else
        if i<=2
            plot([xcenterEV+hc-tcf xcenterEV+hc+tep],[ 0.5*hep-ert-min(1,i-1)*p   0.5*hep-ert-min(1,i-1)*p],'Color',[0.0 0.60 0.0],'LineWidth',3)
        else
            plot([xcenterEV+hc-tcf xcenterEV+hc+tep],[ 0.5*hep-ert-min(1,i-1)*p-pt-max(0,i-3)*p   0.5*hep-ert-min(1,i-1)*p-pt-max(0,i-3)*p],'Color',[0.0 0.60 0.0],'LineWidth',3)
        end
    end
end
for i=1:nCrow
    if Extension=="Double"
        if i<=2
            plot([xcenterEV+hc-tcf xcenterEV+hc+tep],[-0.5*hep+erc+(i-1)*pc -0.5*hep+erc+(i-1)*pc],'r','LineWidth',3)
        else
            plot([xcenterEV+hc-tcf xcenterEV+hc+tep],[-0.5*hep+erc+pc+min(1,i-1)*p   -0.5*hep+erc+pc+min(1,i-1)*p],'r','LineWidth',3)
        end
    else
        plot([xcenterEV+hc-tcf xcenterEV+hc+tep],[-0.5*hep+erc+min(1,i-1)*p   -0.5*hep+erc+min(1,i-1)*p],'r','LineWidth',3)
    end
end
if pi==0
    plot([xcenterEV+hc-tcf xcenterEV+hc+tep],[ 0.0                  0.0],'Color',                 [0.50 0.50 0.50],'LineWidth',3)
end


% Plate Stiffener
if StiffenerP=="Yes"
    patch([xcenterEV+hc+tep xcenterEV+hc+tep xcenterEV+hc+tep+ec],[ hep/2  hep/2-et  hep/2-et],[0.65 0.65 0.65])
    if Extension=="Double"
        patch([xcenterEV+hc+tep xcenterEV+hc+tep xcenterEV+hc+tep+ec],[-hep/2 -hep/2+ec -hep/2+ec],[0.65 0.65 0.65])
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xcenterSV=xcenterEV+hc+1.5*hb+bcf/2;

% Column
if Joint~="Splice"
    if Column=="Rigid"
        rectangle('Position',[xcenterSV-0.5*bcf,-1.5*hep,bcf,3*hep],'FaceColor',[0.5 0.5 0.5],'EdgeColor','k','LineWidth',0.5);
    else
        
        if Axis=="Major"
            
            rectangle('Position',[xcenterSV-0.5*bcf,-1.5*hep,bcf,3*hep],'FaceColor','w','EdgeColor','k','LineWidth',0.5);
            if contains(Column,"SHS")==1
                %rectangle('Position',[xcenterSV-0.5*bcf+tcf,-1.5*hep,  bcf-2*tcf,   3*hep],'FaceColor','w','EdgeColor','k','LineStyle','--','LineWidth',0.5);
                plot([xcenterSV-0.5*bcf+tcf xcenterSV-0.5*bcf+tcf], [-1.5*hep 1.5*hep],'--k','LineWidth',0.5);
                plot([xcenterSV+0.5*bcf-tcf xcenterSV+0.5*bcf-tcf], [-1.5*hep 1.5*hep],'--k','LineWidth',0.5);
            else
                plot([xcenterSV-0.5*tcw xcenterSV-0.5*tcw], [-1.5*hep 1.5*hep],'--k','LineWidth',0.5);
                plot([xcenterSV+0.5*tcw xcenterSV+0.5*tcw], [-1.5*hep 1.5*hep],'--k','LineWidth',0.5);
            end
            
        else
            rectangle('Position',[xcenterSV-0.5*hc,-1.5*hep,hc,3*hep],'FaceColor','w','EdgeColor','k','LineWidth',0.5);
            rectangle('Position',[xcenterSV-0.5*hc+tcf,-1.5*hep,hc-2*tcf,3*hep],'FaceColor','w','EdgeColor','k','LineWidth',0.5);
        end
        
    end
end


% End-plate
rectangle('Position',[xcenterSV-0.5*bep,-0.5*hep,bep,hep],  'FaceColor',[0.85 0.85 0.85],'EdgeColor','k','LineWidth',0.5);

% Beam
rectangle('Position',[xcenterSV-0.5*bbf,-0.5*hep+ec    ,bbf,tbf],     'FaceColor','b','EdgeColor','k','LineWidth',0.5);
rectangle('Position',[xcenterSV-0.5*bbf, 0.5*hep-et-tbf,bbf,tbf],     'FaceColor','b','EdgeColor','k','LineWidth',0.5);
rectangle('Position',[xcenterSV-0.5*tbw,-0.5*hep+ec+tbf,tbw,hb-2*tbf],'FaceColor','b','EdgeColor','k','LineWidth',0.5);

if StiffenerP=="Yes"
    rectangle('Position',[xcenterSV-0.5*tstiffP,0.5*hb,    tstiffP,et],'FaceColor','b','EdgeColor','k','LineWidth',0.5);
    if Extension=="Double"
        rectangle('Position',[xcenterSV-0.5*tstiffP,-0.5*hb-ec,tstiffP,ec],'FaceColor','b','EdgeColor','k','LineWidth',0.5);
    end
end

% Bolt
for i=1:nTrow
    if nTcol==2
        if SingleRowEx=="Yes"
            plot(xcenterSV-0.5*g, 0.5*hep-ert-(i-1)*pt,'ok','Markersize',3.5,'Markerfacecolor',[0.0 0.6 0.0])
            plot(xcenterSV+0.5*g, 0.5*hep-ert-(i-1)*pt,'ok','Markersize',3.5,'Markerfacecolor',[0.0 0.6 0.0])
        else
            if i<=2
                plot(xcenterSV-0.5*g, 0.5*hep-ert-min(1,i-1)*p,'ok','Markersize',3.5,'Markerfacecolor',[0.0 0.6 0.0])
                plot(xcenterSV+0.5*g, 0.5*hep-ert-min(1,i-1)*p,'ok','Markersize',3.5,'Markerfacecolor',[0.0 0.6 0.0])
            else
                plot(xcenterSV-0.5*g, 0.5*hep-ert-min(1,i-1)*p-pt-max(0,i-3)*p,'ok','Markersize',3.5,'Markerfacecolor',[0.0 0.6 0.0])
                plot(xcenterSV+0.5*g, 0.5*hep-ert-min(1,i-1)*p-pt-max(0,i-3)*p,'ok','Markersize',3.5,'Markerfacecolor',[0.0 0.6 0.0])
            end
        end
    else
        g2=DB.g2(SN);
        plot(xcenterSV-0.5*g,  0.5*hep-ert-(i-1)*pt,'ok','Markersize',3.5,'Markerfacecolor',[0.0 0.6 0.0])
        plot(xcenterSV+0.5*g,  0.5*hep-ert-(i-1)*pt,'ok','Markersize',3.5,'Markerfacecolor',[0.0 0.6 0.0])
        plot(xcenterSV-0.5*g2, 0.5*hep-ert-(i-1)*pt,'ok','Markersize',3.5,'Markerfacecolor',[0.0 0.6 0.0])
        plot(xcenterSV+0.5*g2, 0.5*hep-ert-(i-1)*pt,'ok','Markersize',3.5,'Markerfacecolor',[0.0 0.6 0.0])
    end
end
for i=1:nCrow
    if nTcol==2
        if Extension=="Double"
            if i<=2
                plot(xcenterSV-0.5*g,-0.5*hep+erc+(i-1)*pc,'ok','Markersize',3.5,'Markerfacecolor','r')
                plot(xcenterSV+0.5*g,-0.5*hep+erc+(i-1)*pc,'ok','Markersize',3.5,'Markerfacecolor','r')
            else
                plot(xcenterSV-0.5*g,-0.5*hep+erc+pc+(i-1)*p,'ok','Markersize',3.5,'Markerfacecolor','r')
                plot(xcenterSV+0.5*g,-0.5*hep+erc+pc+(i-1)*p,'ok','Markersize',3.5,'Markerfacecolor','r')            
            end
                
        else
            plot(xcenterSV-0.5*g, -0.5*hep+erc+(i-1)*p,'ok','Markersize',3.5,'Markerfacecolor','r')
            plot(xcenterSV+0.5*g, -0.5*hep+erc+(i-1)*p,'ok','Markersize',3.5,'Markerfacecolor','r')
        end
    else
        g2=DB.g2(SN);
        plot(xcenterSV-0.5*g,  -0.5*hep+erc+(i-1)*pc,'ok','Markersize',3.5,'Markerfacecolor','r')
        plot(xcenterSV+0.5*g,  -0.5*hep+erc+(i-1)*pc,'ok','Markersize',3.5,'Markerfacecolor','r')
        plot(xcenterSV-0.5*g2, -0.5*hep+erc+(i-1)*pc,'ok','Markersize',3.5,'Markerfacecolor','r')
        plot(xcenterSV+0.5*g2, -0.5*hep+erc+(i-1)*pc,'ok','Markersize',3.5,'Markerfacecolor','r')
    end
end



if pi==0
    plot(xcenterSV-0.5*g,0.0,'ok','Markersize',3.5,'Markerfacecolor',[0.7 0.7 0.7])
    plot(xcenterSV+0.5*g,0.0,'ok','Markersize',3.5,'Markerfacecolor',[0.7 0.7 0.7])
end

%% Add text desciption
SpecimenID = strrep(SpecimenID,'_','-');
text(0.0,1.8*hep,['Specimen ID: ', char(SpecimenID)],'Fontname','times','fontsize',12);
text(0.9*(hc+1.5*hb+bcf),1.8*hep,['beta version'],'Fontname','times','fontsize',12);
i=1;
str{i}=['Beam    : ',char(Beam),' (',char(GradeB),')'];i=i+1;
str{i}=['Column : ',char(Column),' (',char(GradeC),')'];i=i+1;
str{i}=['Plate      : ',num2str(hep),' x ',num2str(bep),' x ',num2str(tep),' (',char(GradeP),')'];i=i+1;
str{i}=['Bolts      : ',num2str(nTotal),' ',char(BoltSize),' (Gr. ',char(GradeBolt),')'];i=i+1;
% str{i}=['Axis    : ',char(Axis)];i=i+1;
% if Slab=="Yes"; str{i}=['Slab : ',num2str(hslab),' x ',num2str(Wslab)];i=i+1; end
text(0,-2*hep,str,'Fontname','times','fontsize',8);
