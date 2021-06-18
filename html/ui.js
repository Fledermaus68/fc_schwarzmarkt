$(document).ready(function() {
    window.addEventListener('message', function(event) {
        if (event.data.action == "open") {
            $(".main").css("display", "block");
        } else if (event.data.action == "close") {
            $(".main").css("display", "none");
        } else if (event.data.action == "add") {
            AddItem(event.data.itemName, event.data.label, event.data.price, event.data.type)
        } else {
            $(".main").css("display", "none");
        }
    });
});

$("#close").click(function() {
    $('.main').css('display', 'none');
    $.post('http://fc_schwarzmarkt/close', JSON.stringify({}));
});

$(".main").on("click", "#buy", function() {
    var $button = $(this);
    var $itemName = $button.attr("itemName");
    var $price = $button.attr("price");
    var $label = $button.attr("label");
    var $type = $button.attr("type");

    $.post('http://fc_schwarzmarkt/buy', JSON.stringify({
        itemName: $itemName,
        price: $price,
        label: $label,
        type: $type
    }));
    $('.main').css('display', 'none');
    $.post('http://fc_schwarzmarkt/close', JSON.stringify({}));
});

function AddItem(itemName, label, price, type) {
    $(".main").append(`
    <div id="item">
    <p id="item-name">` + label + `</p>
    <p id="item-price">$` + price + `</p>
    <img id="item-icon" src="img/` + itemName + `.png">
    <button class="button" type="` + type + `" label="` + label + `" itemName="` + itemName + `" price="` + price + `" id="buy" style="background-color: #3bb33d;" type="submit">Kaufen</button>
    </div>
    `);
}