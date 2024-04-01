return {
    {
        'ThePrimeagen/harpoon',
        config = function()
            require('config/remap').map_harpoon()
            return {}
        end,
    }
}
