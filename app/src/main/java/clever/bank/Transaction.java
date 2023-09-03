package clever.bank;

import java.beans.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Scanner;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {

    private static final String url = "jdbc:postgresql://localhost/cleverbank";
    private static final String user = "postgres";
    private static final String password = "changeme";

    private static Connection con;
    private PreparedStatement statement, stmt;
    private static ResultSet rs;
    private Statement stat;

    protected long txnId;
    protected char type;
    protected Double amount;
    protected String info;

    String amountToTransfer;

    public void topUp(Account ac, Double addTobalance) throws IllegalArgumentException {

        try {

            con = DriverManager.getConnection(url, user, password);

            java.util.Date utilDate = Calendar.getInstance().getTime();
            java.sql.Date startDate = new java.sql.Date(utilDate.getTime());

            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount_start_ts = ? WHERE acc_id = ?");
            stmt.setString(2, ac.getAccId());
            stmt.setDate(1, startDate);
            stmt.executeUpdate();

            if (addTobalance <= 19.99)
                throw new IllegalArgumentException("Сумма для пополнения не должна быть  меньше 20 единиц.");
            ac.balance += addTobalance;
            utilDate = Calendar.getInstance().getTime();
            java.sql.Date endDate = new java.sql.Date(utilDate.getTime());
            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount_end_ts = ? WHERE acc_id = ?");
            stmt.setString(2, ac.getAccId());
            stmt.setDate(1, endDate);
            stmt.executeUpdate();

            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount = ? WHERE acc_id = ?");
            stmt.setString(2, ac.getAccId());
            stmt.setDouble(1, ac.getBalance());
            stmt.executeUpdate();

            stmt = con.prepareStatement(
                    "INSERT INTO bank_transactions(txn_type,txn_acc_id_from, txn_acc_id_to, amount) VALUES(?, ?, ?, ?)");
            stmt.setString(1, "+");
            stmt.setString(2, ac.getAccId());
            stmt.setString(3, ac.getAccId());
            stmt.setDouble(4, addTobalance);
            stmt.executeUpdate();
        } catch (SQLException sqlEx) {
            sqlEx.printStackTrace();
        }

    }

    public void withdraw(Account ac, Double balanceToSubstract) throws IllegalArgumentException {
        try {

            con = DriverManager.getConnection(url, user, password);
            java.util.Date utilDate = Calendar.getInstance().getTime();
            java.sql.Date startDate = new java.sql.Date(utilDate.getTime());

            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount_start_ts = ? WHERE acc_id = ?");
            stmt.setString(2, ac.getAccId());
            stmt.setDate(1, startDate);
            stmt.executeUpdate();

            if (ac.balance < balanceToSubstract)
                throw new IllegalArgumentException("Недостаточно средств для выполнения операции.");
            ac.balance -= balanceToSubstract;

            utilDate = Calendar.getInstance().getTime();
            java.sql.Date endDate = new java.sql.Date(utilDate.getTime());
            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount_end_ts = ? WHERE acc_id = ?");
            stmt.setString(2, ac.getAccId());
            stmt.setDate(1, endDate);
            stmt.executeUpdate();

            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount = ? WHERE acc_id = ?");
            stmt.setString(2, ac.getAccId());
            stmt.setDouble(1, ac.getBalance());
            stmt.executeUpdate();

            stmt = con.prepareStatement(
                    "INSERT INTO bank_transactions(txn_type,txn_acc_id_from, txn_acc_id_to, amount) VALUES(?, ?, ?, ?)");
            stmt.setString(1, "-");
            stmt.setString(2, ac.getAccId());
            stmt.setString(3, ac.getAccId());
            stmt.setDouble(4, balanceToSubstract);
            stmt.executeUpdate();

        } catch (SQLException sqlEx) {
            sqlEx.printStackTrace();
        }
    }

    void isEnough(Account ac, Double amountToTransfer) throws IllegalArgumentException {
        if (ac.getBalance() < amountToTransfer)
            throw new IllegalArgumentException("Недостаточно средств.");
    }

    public void moneyTransaction(Account acb1, Double amountToTransfer) throws IllegalArgumentException {

        Scanner sc = new Scanner(System.in);

        Double amount;

        Account acb2 = new Account();
        try {
            con = DriverManager.getConnection(url, user, password);
            System.out.println("Введите номер счета, на который Вы желаете перевести средства");
            String acc_id = sc.nextLine();
            statement = con.prepareStatement("SELECT * from bank_acc_balance WHERE  acc_id = ?");
            statement.setString(1, acc_id);

            rs = statement.executeQuery();

            while (rs.next()) {
                acb2.setAccId(rs.getString(1));
                acb2.setBalance(rs.getDouble(2));
            }

            java.util.Date utilDate = Calendar.getInstance().getTime();
            java.sql.Date startDate = new java.sql.Date(utilDate.getTime());

            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount_start_ts = ? WHERE acc_id = ?");
            stmt.setString(2, acb1.getAccId());
            stmt.setDate(1, startDate);
            stmt.executeUpdate();

            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount_start_ts = ? WHERE acc_id = ?");
            stmt.setString(2, acb2.getAccId());
            stmt.setDate(1, startDate);
            stmt.executeUpdate();

            amount = amountToTransfer;
            isEnough(acb1, amountToTransfer);
            acb1.balance -= amount;
            acb2.balance += amount;

            utilDate = Calendar.getInstance().getTime();
            java.sql.Date endDate = new java.sql.Date(utilDate.getTime());
            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount_end_ts = ? WHERE acc_id = ?");
            stmt.setString(2, acb1.getAccId());
            stmt.setDate(1, endDate);
            stmt.executeUpdate();

            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount_end_ts = ? WHERE acc_id = ?");
            stmt.setString(2, acb2.getAccId());
            stmt.setDate(1, endDate);
            stmt.executeUpdate();

            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount = ? WHERE acc_id = ?");
            stmt.setString(2, acb1.accId);
            stmt.setDouble(1, acb1.balance);
            stmt.executeUpdate();

            stmt = con.prepareStatement("UPDATE bank_acc_balance SET amount = ? WHERE acc_id = ?");

            stmt.setString(2, acb2.accId);
            stmt.setDouble(1, acb2.balance);
            stmt.executeUpdate();

            stmt = con.prepareStatement(
                    "INSERT INTO bank_transactions(txn_type,txn_acc_id_from, txn_acc_id_to, amount) VALUES(?, ?, ?, ?)");
            stmt.setString(1, ">");
            stmt.setString(2, acb1.getAccId());
            stmt.setString(3, acb2.getAccId());
            stmt.setDouble(4, amount);
            stmt.executeUpdate();

        } catch (SQLException sqlEx) {
            sqlEx.printStackTrace();
        }

        finally {

            try {
                con.close();
            } catch (SQLException se) {
            }
            try {
                stmt.close();
                statement.close();
            } catch (SQLException se) {
            }
            try {
                rs.close();
            } catch (SQLException se) {
            }
        }

    }
}
