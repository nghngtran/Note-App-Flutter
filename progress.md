# Tiến độ
- #### [1/10]Tạo Note:
	- [:heavy_check_mark:] Thông tin cơ bản của Note(Title)
	- [0/6] Thành phần Nội dung của Note:
		- [0/4] Img: content:={path of file}
			- [:heavy_check_mark:]Loadfrom Gallery:
			- [:heavy_check_mark:]From Camera:
			- []Trường hợp edit: Save file sau khi kết thúc edit
			- []Trường hợp không edit: 
		- [0/2] Audio: content:={path of file}
			- [:heavy_check_mark:]Loadfrom device:
			- []Record: Trường hợp máy k có record trả về và báo lỗi
		- [:heavy_check_mark:] Text: content:={content}
	- [0/3] AddTag:
		- [:heavy_check_mark:] Hiển thị tất cả tag đã có dưới DB, trừ những tag đã được thêm vào
		- [:heavy_check_mark:] Tạo tag mới: báo lỗi nếu tạo fail
		- [:heavy_check_mark:] Không hiển thị 1 tag nhiều hơn 1 lần
- #### [0/2] Xóa Note:
	- [] Xóa đơn bên trong View Note
	- [] Xóa nhiều mục ngoài Home
- #### [0/4] View Note & Edit Note:
	- [] Xóa tag ra khỏi Note: 
	- [] Load đầy đủ 1 note lên
	- [] Edit các field
	- [] Save gọi update
- #### [2/5] Load Home:
	- [] Add Tag: gọi add tag(có kiểm tra true false, không hiển thị 1 tag nhiều hơn 1 lần)
	- [] View Tag Info: ấn giữ vào tag
	- [:heavy_check_mark:] Xóa Tag trong View Tag Info
	- [:heavy_check_mark:] Load list Thumbnail từ DB
	- [:heavy_check_mark:] Load list tag từ db
- #### [2/6] Search:
	- [0/4] Search by Tag:
		- [] Ấn vào tag ngoài Home
		- [:heavy_check_mark:] gõ #{têntag} trên search bar
		- [:heavy_check_mark:] Khi hiển thị kết quả search bar hiện tên và màu tag
		- :heavy_check_mark:] Load list thumbnail by tag
	- [2/2] Search by keyword:Áp dụng cho cả content và title của Note, ưu tiên title 
		- [:heavy_check_mark:] gõ keyword trên search bar
		- [:heavy_check_mark:] Load list thumbnail by findkeyword

			
