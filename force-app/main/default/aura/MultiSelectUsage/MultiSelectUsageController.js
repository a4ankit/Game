({
	doInit : function(component, event, helper) {
        const options=[{'Id':1,'Name':'Jaipur'},
                       {'Id':2,'Name':'Pune'},
                       {'Id':3,'Name':'Hyderabad'},
                       {'Id':4,'Name':'Banglore'},
                       {'Id':5,'Name':'Gurgaon'},
                       {'Id':6,'Name':'Mumbai'},
                       {'Id':7,'Name':'Chennai'},
                       {'Id':8,'Name':'Noida'},
                       {'Id':9,'Name':'Delhi'},];
        component.set("v.options", options);
	}
})