$(function() {
    // 选中a标签, 点击事件
    $('a[href*=#]:not([href=#])').click(function() {
        // 判断是否是本页anchor
        // location链接的地址, pathname取站内地址, replace去掉了backslash
        if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
            // 取出anchor赋值给target
            var target = [this.hash];
            console.log(target.length);
            // 判断长度, 大于1(选择成功)返回target; 等于0(选择失败)选择name属性
            target = target.length ? target : $('[name=' + this.hash.slice(1) +']');

            if (target.length) {
                $('html,body').animate({
                    scrollTop: target.offset().top
                }, 1000);
                return false;
            }
        }
    });
});
