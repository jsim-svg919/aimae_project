document.addEventListener('DOMContentLoaded', () => {
        // 섹션 전환
        const sections = {manageUsers:'usersSection', manageOrders:'ordersSection', manageProducts:'productsSection'};
        Object.keys(sections).forEach(btnId=>{
            document.getElementById(btnId).addEventListener('click', e=>{
                e.preventDefault();
                Object.values(sections).forEach(sec=>document.getElementById(sec).style.display='none');
                document.getElementById(sections[btnId]).style.display='block';
            });
        });

        // 모달 제어
        const addBtn = document.getElementById('showAddProductForm');
        const modal = document.getElementById('addProductModal');
        const closeBtn = modal.querySelector('.close-btn');
        const cancelBtn = document.getElementById('cancelAddProduct');
        const form = document.getElementById('addProductForm');
        const tableBody = document.getElementById('productTableBody');

        addBtn.addEventListener('click', () => modal.style.display = 'flex');
        closeBtn.addEventListener('click', () => modal.style.display = 'none');
        cancelBtn.addEventListener('click', () => modal.style.display = 'none');
        window.addEventListener('click', e => { if(e.target === modal) modal.style.display = 'none'; });

        // 상품 등록
        form.addEventListener('submit', e => {
            e.preventDefault();
            const name = form.name.value;
            const stock = form.stock.value;
            const price = form.price.value;
            const row = document.createElement('tr');
            const newId = '#P' + (tableBody.children.length + 1).toString().padStart(3, '0');
            row.innerHTML = `<td>${newId}</td><td>${name}</td><td>${stock}</td><td>₩${parseInt(price).toLocaleString()}</td>
            <td>
                <button class="edit-btn"><i class="fa-solid fa-pen"></i></button>
                <button class="delete-btn"><i class="fa-solid fa-trash"></i></button>
            </td>`;
            tableBody.appendChild(row);
            modal.style.display = 'none';
            form.reset();
        });

        // 삭제 버튼 이벤트 (동적 생성 row 포함)
        tableBody.addEventListener('click', e => {
            if(e.target.closest('.delete-btn')) {
                const tr = e.target.closest('tr');
                tr.remove();
            }
        });
    });