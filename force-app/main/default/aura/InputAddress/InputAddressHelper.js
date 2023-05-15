({
    countryProvinceMap: {
        US: [
            {'label': 'California', 'value': 'CA'},
            {'label': 'Texas', 'value': 'TX'},
            {'label': 'Washington', 'value': 'WA'},
        ],
        CN: [
            {'label': 'GuangDong', 'value': 'GD'},
            {'label': 'GuangXi', 'value': 'GX'},
            {'label': 'Sichuan', 'value': 'SC'},
        ],
        VA: [
            {'label': 'Test1', 'value': 'GD'},
            {'label': 'Test2', 'value': 'GX'},
            {'label': 'Test3', 'value': 'SC'},
        ],
    },
    countryOptions: [
        {'label': 'United States', 'value': 'US'},
        {'label': 'China', 'value': 'CN'},
        {'label': 'Vatican', 'value': 'VA'},
    ],
    getProvinceOptions: function(country) {
        return this.countryProvinceMap[country];
    },
    getCountryOptions: function() {
        return this.countryOptions;
    }
})