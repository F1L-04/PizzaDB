import javax.swing.*;
import javax.swing.plaf.nimbus.State;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class Interfaccia extends JFrame{
    private JPanel panel1;
    private JTextArea textArea1;
    private JButton visualizzaButton;
    private JTextField textField1;
    private JTextField textField2;
    private JButton inserisciButton1;
    private JButton modificaButton;
    private JButton cancellaButton;
    private Connection c;

    public Interfaccia(){

        //Connessione Database
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url="jdbc:mysql://localhost:3306/Ordini";
            c=DriverManager.getConnection(url,"root","Filip2004!");
            System.out.println("Connessione a Database riuscita");
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Connessione al Database non riuscita");
            throw new RuntimeException(e);
        }

        this.inserisciButton1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                boolean nuovo=true;
                int n;
                try {
                    String Pizza=textField1.getText();
                    double Prezzo=Double.parseDouble(textField2.getText());
                    Statement st = c.createStatement(); //Rappresenta l'istruzione SQL
                    ResultSet rs=st.executeQuery("SELECT * FROM Pizza"); //lancia una query
                    while(rs.next()){
                        String p=rs.getString("Nome");
                        if(p.compareToIgnoreCase(Pizza)==0){
                            nuovo=false;
                        }
                    }
                    if(nuovo) {
                        n = st.executeUpdate("INSERT INTO Pizza " + "VALUES ('" + Pizza + "'," + Prezzo + ")");
                        textArea1.setText("Pizza inserita");
                    }else{
                        textArea1.setText("Pizza già presente");
                    }
                } catch (SQLException ex) {
                    throw new RuntimeException(ex);
                }
            }
        });

        this.modificaButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    boolean presente=false;
                    int n;
                    Statement st = c.createStatement();
                    String Pizza=textField1.getText();
                    double Prez=Double.parseDouble(textField2.getText());
                    ResultSet rs=st.executeQuery("SELECT * FROM Pizza"); //lancia una query
                    while(rs.next()){
                        String p=rs.getString("Nome"); //prende elemento della tabella Pizza nella Colonna Nome
                        if(p.compareToIgnoreCase(Pizza)==0){
                            presente=true;
                        }
                    }
                    if(presente) {
                        String updateString = "UPDATE Pizza SET Prezzo="+Prez+" " +"WHERE Nome='"+Pizza+"'"; //Segna istruzione UPDATE
                        int resultUpdate = 0;
                        if((resultUpdate = st.executeUpdate(updateString))==1)  //Esegue UPDATE
                            textArea1.setText("Modifica avvenuta con successo");
                    }else{
                        textArea1.setText("Pizza non presente nell'elenco");
                    }
                } catch (SQLException ex) {
                    throw new RuntimeException(ex);
                }
            }
        });

        this.cancellaButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                boolean presente=false;
                int n;
                try {
                    String Pizza=textField1.getText();
                    double Prezzo=Double.parseDouble(textField2.getText());
                    Statement st = c.createStatement(); //Rappresenta l'istruzione SQL
                    ResultSet rs=st.executeQuery("SELECT * FROM Pizza"); //lancia una query
                    while(rs.next()){
                        String p=rs.getString("Nome"); //prende elemento della tabella Pizza nella Colonna Nome
                        if(p.compareToIgnoreCase(Pizza)==0){
                            presente=true;
                        }
                    }
                    if(presente) {
                        n = st.executeUpdate("DELETE FROM Pizza WHERE Nome='"+Pizza+"'"); //Esegue DELETE
                        textArea1.setText("Pizza cancellata");
                    }else{
                        textArea1.setText("Pizza non presente nell'elenco");
                    }
                } catch (SQLException ex) {
                    textArea1.setText("Pizza non cancellabile in quanto collegata ad altri elementi");
                    throw new RuntimeException(ex);
                }
            }
        });

        this.visualizzaButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                textArea1.setText("Tabella\n");
                textArea1.append("Nome Pizza\tNum Prezzo\n");
                try {
                    Statement st = c.createStatement(); //Rappresenta l'istruzione SQL
                    ResultSet rs=st.executeQuery("SELECT * FROM Pizza"); //lancia una query
                    while(rs.next()){
                        String Pizza=rs.getString("Nome");
                        double Prezzo=rs.getInt("Prezzo");
                        textArea1.append(Pizza+"\t"+Prezzo+"\n");
                    }
                } catch (SQLException ex) {
                    throw new RuntimeException(ex);
                }

            }
        });
    }

    public static void main(String[] args) {
        Interfaccia i=new Interfaccia();
        i.add(i.panel1);
        i.setSize(400,300);
        i.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        i.setVisible(true);
    }
}
