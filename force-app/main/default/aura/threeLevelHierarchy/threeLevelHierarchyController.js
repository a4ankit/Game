({
    init: function (cmp) {
        var items = [{
                            label: 'Facility',
                            name: 'Facility',
                            expanded: false,
                            disabled: false,
                            items: [
                                {
                                    label: 'Facility1',
                                    name: 'Facility1',
                                    disabled: false,
                                    items: [],
                                },
                                {
                                    label: 'Facility2',
                                    name: 'Facility2',
                                    disabled: false,
                                    items: [],
                                },
                                {
                                    label: 'Facility3',
                                    name: 'Facility3',
                                    disabled: false,
                                    items: [],
                                },
                                {
                                    label: 'Manager',
                                    name: '1.2.1.1',
                                    expanded: false,
                                    disabled: false,
                                    items: [{
                                        label: 'Manager1',
                                        name: 'Manager1',
                                        disabled: false,
                                        items: [],
                                    },
                                    {
                                        label: 'Manager2',
                                        name: 'Manager2',
                                        disabled: false,
                                        items: [],
                                    },
                                    {
                                        label: 'Manager3',
                                        name: 'Manager3',
                                        disabled: false,
                                        items: [],
                                    },
                                        {
                                            label: 'Employee',
                                            name: '1.2.1.1.2',
                                            disabled: false,
                                            expanded: false,
                                            items: [{
                                                label: 'Employee1',
                                                name: 'Employee1',
                                                disabled: false,
                                                items: [],
                                            },
                                            {
                                                label: 'Employee2',
                                                name: 'Employee2',
                                                disabled: false,
                                                items: [],
                                            },
                                            {
                                                label: 'Employee3',
                                                name: 'Employee3',
                                                disabled: false,
                                                items: [],
                                            }],
                                        }]
                                },
                            ],
                        },
                    ]
        cmp.set('v.items', items);
    }
})