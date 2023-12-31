Консольное приложение Clever-Bank

Тестовое задание Clevertec

 Консольное приложение Clever-Bank позволяет авторизированным клиентам совершать различные транзакции: пополнение счета, снятие средств, перевод средств на другой счет.
 
 В начале сеанса пользователю предлагается ввести уникальный идентификационный номер, который был указан при регистрации, после чего станет возможным выбор операции.
 
 Для подтверждения своих действий необходимо вводить номер счета. Таким образом обеспечена безопасность проведения транзакций.
 
 Для пополнения счета и снятия средств пользователю потребуется ввести номер счета и нужную ему сумму. 
 
 При выполнении перевода средств на другой счет отправителю необходимо ввести номер счета получателя.
 
 Важно учитывать, что сумма, которую клиент желает снять со своего счета или перевести кому-либо, не должна превышать баланс на текущем счету. Сумма, которая будет внесена на счет при пополнении, должна быть не меньше 20 единиц. 
 
 После каждой операции формируется чек в виде текстового документа, который будет сохранен в папку check в корне проекта. Название файла формируется из текущей даты, времени проведения операции и числа, сгенерированного случайным образом. 
 
 Все данные хранятся в базе данных cleverbank. Она состоит из нескольких связанных между собой таблиц, в которых содержатся сведения о банках, клиентах, их счетах в этих банках, балансах на счетах и проводимых транзакциях. Организация таблиц представлена в файле cleverbank_ddl.sql.
 
 Для обновления, изменения, добавления, удаления данных и поддержания актуального состояния информации были использованы sql-команды. 
 
 Проверка корректности работы методов сервиса осуществляется с помощью unit-тестов. 

 Приложение можно запустить в Вашей среде разработки. При возникновении ошибок проверьте правильность пути сохранения чеков и запустите в режиме Run and Debug.

 
