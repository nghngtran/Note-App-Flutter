# Document for Database NoteApp

Built and maintained by our [Collaborators](#collaborators)

```
All data access must to use BUS class
```
:hammer_and_wrench:
:heavy_check_mark:
:warning:
:exclamation:
## Lớp NoteBUS:  
###### Status: :hammer_and_wrench:
**Mô tả**: NoteBUS cung cấp các phương thức để thực hiện các thao tác với table note

**1. Khởi tạo**

- *Tham số:* **`Không`**

- *Trả về:* **`Object`** 

- Cú pháp:` var notebus = new NoteBUS();`

**2. Thêm record vào bảng**

- *Tham số:* **`Note`** Object

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await notebus.addNote(Notes note);`

**3. Update record vào bảng**

- *Tham số:* **`Note`** Object

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await notebus.updateNote(String noteId);`

**4. Xóa 1 record với ID xác định khỏi bảng**

- *Tham số:* **`String`** NoteID

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await notebus.deleteNote(String noteId);`

**5. Xóa tất cả record khỏi bảng**

- *Tham số:* **`Không`**

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await notebus.deleteAllNote();`

**6. Lấy 1 Note object từ bảng**

- *Tham số:* **`String`** ID

- *Trả về:* **`Note`** :**object** nếu thành công, **`null`** nếu thất bại

- Cú pháp:` Note note = await notebus.getNoteById(String noteId);`

**7. Lấy tất cả Note object từ bảng**

- *Tham số:* **`Không`**

- *Trả về:* **`List<Note>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<Note> notes = await notebus.getNotes();`

**8. Lấy tất cả Note object với Query String từ bảng**

- *Tham số:* **`String`** Query

- *Trả về:* **`List<Note>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<Note> notes = await notebus.getNotes(String Query);`

## ![✔] Lớp TagBUS:  
###### Status: :heavy_check_mark:![✔]
**Mô tả**: TagBUS cung cấp các phương thức để thực hiện các thao tác với table tag

**1. Khởi tạo**

- *Tham số:* **`Không`**

- *Trả về:* **`Object`** 

- Cú pháp:` var tagbus = new TagBUS();`

**2. Thêm record vào bảng**

- *Tham số:* **`Tag`** object

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await tagbus.addTag(Tag tag);`

**3. Update record vào bảng**

- *Tham số:* **`Tag`** object

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await tagbus.updateTag(Tag tag);`

**4. Xóa 1 record với ID xác định khỏi bảng**

- *Tham số:* **`String`** tagId

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await tagbus.deleteTagById(String tagId);`

**5. Xóa tất cả record khỏi bảng**

- *Tham số:* **`Không`**

- *Trả về:* **`Boolean`** :**`True`** nếu thành công, **`False`** nếu thất bại

- Cú pháp:` boolean status = await tagbus.deleteAll();`

**6. Lấy 1 Tag object từ bảng**

- *Tham số:* **`String`** ID

- *Trả về:* **`Tag`** :**object** nếu thành công, **`null`** nếu thất bại

- Cú pháp:` Tag tag = await tagbus.getTagById(String tagId);`

**7. Lấy tất cả Tag object từ bảng**

- *Tham số:* **`Không`**

- *Trả về:* **`List<Tag>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<Tag> tags = await tagbus.getTags();`

**8. Lấy tất cả Tag object với Query String từ bảng**

- *Tham số:* **`String`** Query

- *Trả về:* **`List<Tag>`** :**`list<object>`** nếu thành công, **`[]`** nếu thất bại

- Cú pháp:` List<Tag> tags = await tagbus.getTags(String Query);`
***
To be continute

Lớp ThumbnailBUS:
- Khởi tạo: var thumbnail_bus = new ThumbnailBUS();
- thêm record vào bảng "thumbnails" : thumbnail_bus.addThumbnail(ThumbnailNote note);
- update record : thumbnail_bus.updateThumbnail(ThumbnailNote note);
- xóa 1 record : thumbnail_bus.deleteThumbnailById(String note_id);
- xóa tất cả record : thumbnail_bus.deleteAll();
- trả về 1 record với note_id có sẵn : thumbnail_bus.getThumbnailById(String note_id);
- trả về tất cả record với filter : thumbnail_bus.getThumbnails(String Query);
- trả về tất cả record : thumbnail_bus.getThumbnails();
