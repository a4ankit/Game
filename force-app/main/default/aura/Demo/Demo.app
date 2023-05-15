<aura:application extends="force:slds">
    <ltng:require styles="/resource/SLDS_2_0_3/assets/styles/salesforce-lightning-design-system.css" />
    <div> 
        <div style="width:400px;height:150px;">
            <c:FlipCard borderColor="#16325c" bgColor="#16325c" fontColor="#FFF" frontText="Why are you eagerly waiting for IPhone 7 ?" backText="Wireless earpods, fast processor, Dual Camera..." />
        </div>
        <div style="width:400px;height:150px;">
            <c:FlipCard borderColor="#e8e9ec" bgColor="#f4f6f9" fontColor="#000" frontText=" Salesforce Shield Platform Encryption" backText="Shield Platform Encryption gives your data a whole new layer of security while preserving critical platform functionality. " isVerticalFlip="true"/>
        </div>
    </div>
    <c:Confetti />
    <c:Game />
</aura:application>