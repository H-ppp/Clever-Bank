package clever.bank;

import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class App {

    private static final String url = "jdbc:postgresql://localhost/cleverbank";
    private static final String user = "postgres";
    private static final String password = "changeme";
    private PreparedStatement statement, stinit, sbank;

    private static Connection con;
    private static ResultSet rs;

    String txnAmount, bankFrom, bankTo, IdBankFrom, IdBankTo, shortId;
    Double txn;
    int choice;

    public Transaction tr = new Transaction();

    public void menu() throws FileNotFoundException, UnsupportedEncodingException {
        Account ac = new Account();
        Scanner sc = new Scanner(System.in);
        Client cl = new Client();
        CheckMaker chckm = new CheckMaker();
        while (true) {
            int num = (int) (Math.random() * 90000 + 10000);
            try {
                con = DriverManager.getConnection(url, user, password);
                System.out.println("Введите идентификационный номер");
                String clienId = sc.nextLine();
                stinit = con.prepareStatement("SELECT * from bank_accounts WHERE acc_client_id = ?");
                stinit.setString(1, clienId);
                rs = stinit.executeQuery();
                while (rs.next()) {
                    ac.setAccIdWithinBank(rs.getString(2));
                    cl.setClientId(rs.getString(3));
                }
                shortId = ac.getAccIdWithinBank();
                stinit = con.prepareStatement("SELECT * from bank_clients WHERE client_id = ?");
                stinit.setString(1, cl.getClientId());
                rs = stinit.executeQuery();

                while (rs.next()) {
                    cl.setClientName(rs.getString(2));
                    IdBankFrom = rs.getString(3);
                }

                System.out.println("Здравствуйте, " + cl.getClientName());

                sbank = con.prepareStatement("SELECT * from banks WHERE bank_id = ?");
                sbank.setString(1, IdBankFrom);
                rs = sbank.executeQuery();

                while (rs.next()) {
                    bankFrom = rs.getString(2);
                }

                System.out.println("Выберите действие: ");
                System.out.println("Пополнить счет (1) Снять сумму (2) Осуществить перевод (3) Выход (4)");
                choice = sc.nextInt();
                sc.nextLine();
                System.out.println("Введите номер Вашего счета");
                String acc_id = sc.nextLine();

                statement = con.prepareStatement("SELECT * from bank_acc_balance WHERE  acc_id = ?");
                statement.setString(1, acc_id);
                rs = statement.executeQuery();
                while (rs.next()) {
                    ac.setAccId(rs.getString(1));
                    ac.setBalance(rs.getDouble(2));
                }
                if (choice == 1) {
                    System.out.println("Введите сумму");
                    txnAmount = sc.nextLine();
                    txn = Double.parseDouble(txnAmount);

                    tr.topUp(ac, txn);
                    chckm.printCheck(num, "Пополнение", bankFrom, shortId, txn);
                }
                if (choice == 2) {
                    System.out.println("Введите сумму");
                    txnAmount = sc.nextLine();
                    txn = Double.parseDouble(txnAmount);

                    tr.withdraw(ac, txn);
                    chckm.printCheck(num, "Снятие", bankFrom, shortId, txn);
                }
                if (choice == 3)

                {
                    System.out.println("Введите сумму");
                    txnAmount = sc.nextLine();
                    txn = Double.parseDouble(txnAmount);
                    tr.moneyTransaction(ac, txn);
                    chckm.printCheck(num, "Перевод", bankFrom, shortId, txn);
                }

                if (choice == 4) {
                    System.out.println("Завершение сеанса... ");
                    System.exit(0);
                }

            } catch (SQLException sqlEx) {
                sqlEx.printStackTrace();
            }

            finally {

                try {
                    con.close();
                } catch (SQLException se) {
                }
                try {
                    statement.close();
                    stinit.close();
                } catch (SQLException se) {
                }

                try {
                    rs.close();
                } catch (SQLException se) {
                }
            }
        }

    }

    public String getGreeting() {
        return "Добро пожаловать в Clever-Bank!";
    }

    public static void main(String[] args) {

        App ap = new App();
        System.out.println(new App().getGreeting());
        try {
            ap.menu();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }
}
