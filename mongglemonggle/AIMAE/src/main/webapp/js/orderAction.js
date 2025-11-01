// 페이지 로드 시 totalPrice 계산
	function updateTotalPrice() {
	    let total = 0;
	    document.querySelectorAll('[id^="itemTotal_"]').forEach(el => {
	        const price = parseInt(el.innerText.replace(/,/g, '')) || 0;
	        total += price;
	    });
	    document.getElementById("totalPrice").innerText = "₩ " + total.toLocaleString() + "원";
	}

	// 수량 변경
	function changeQty(productId, num) {
	    const qtyInput = document.getElementById(`quantity_${productId}`);
	    let quantity = Math.max(1, parseInt(qtyInput.value) + num);
	    qtyInput.value = quantity;

	    const price = parseInt(document.getElementById(`itemTotal_${productId}`).dataset.price);
	    const itemTotal = price * quantity;
	    document.getElementById(`itemTotal_${productId}`).innerText = itemTotal.toLocaleString();

	    updateTotalPrice();
	}

	// 초기 로드 시 계산
	window.addEventListener('DOMContentLoaded', (event) => {
	    updateTotalPrice();
	});