
# Analyse a l'aide de L'AFC 
#install.packages("FactoMineR")
library(FactoMineR)
#install.packages("factoextra")
library(factoextra)


m <- m[-1,-1]
matrix <- as.table(m)



summary(as.table(m))

chisq <- chisq.test (m)
chisq
#les variables de ligne et de colonne sont statistiquement significativement associ??es

#calculer l???AFC
m.afa=CA(m)
#Valeurs propres / Variances
eig.val <- get_eigenvalue(m.ca)
eig.val

#100% de la variance est expliqu??e par les deux dimensions.
# les deux dimensions repr??sentent la totalit?? de la variabilit??.

#Une autre m??thode pour d??terminer le nombre de dimensions est de regarder le graphique des valeurs propres avec une droite en pointill??e rouge sp??cifiant la valeur propre moyenne

fviz_screeplot (m.ca) +
  geom_hline (yintercept = 33.33, linetype = 2, color = "red")

#Selon le graphique ci-dessus,les deux  dimensions doivent ??tre consid??r??es pour l???interpr??tation de la solution

#Visualisation et interpr??tation
fviz_ca_biplot (m.ca, repel = F)

# repel = TRUE pour ??viter le chevauchement de texte
fviz_ca_biplot (m.ca, repel = TRUE)

#interpretation 
#Ce graphique montre que: 
#   les lignes supprim ,suppress et cr?? sont associ??es le le plus ?? la colonne plan??te.txt
# les lignes mondial,mond, continent  sont associ??es le le plus ?? la colonne sport.txt
# les lignes  vol, arriv, jour,bas  sont associ??es le le plus ?? la colonne economie.txt



fviz_ca_row(m.ca, repel = TRUE)

fviz_ca_row (m.ca, col.row = "steelblue", shape.row = 15)
#Le graphique ci-dessus montre les relations entre les points lignes:
#Les lignes avec un profil similaire sont regroup??es.
#Les lignes corr??l??es n??gativement sont positionn??es sur des c??t??s oppos??s de l???origine de du graphique (quadrants oppos??s).
#La distance entre les points lignes et l???origine mesure la qualit?? des points lignes sur le graphique. Les points lignes qui sont loin de l???origine sont bien repr??sent??s sur le graphique.



################Qualit?? de repr??sentation des lignes


# Colorer en fonction du cos2:
fviz_ca_row (m.ca, col.row = "cos2",
            
             repel = F,title="Graphe de qualit?? de repr??sentation des mots")

fviz_cos2(m.ca, choice = "row", axes = 1:2 )

#les variables ?? faible valeur cos2 seront color??es en ???white??? (blanc)
#les variables avec des valeurs moyennes de cos2 seront color??es en ???blue??? (bleu)
#les variables avec des valeurs ??lev??es de cos2 seront color??es en ???red??? (rouge)

################Contributions des lignes aux dimensions
# Contributions des lignes ?? la dimension 1
fviz_contrib(m.ca, choice = "row", axes = 1, top = 20
             )
# Contributions des lignes ?? la dimension 2
fviz_contrib(m.ca, choice = "row", axes = 2, top = 10)

# Contribution des lignes totale aux dimensions 1 et 2
fviz_contrib (m.ca, choice = "row", axes = 1:2, top = 10
              ,title="Contribution des mots dans les deux  dimensions 1 et 2 pour les top 10")

#Les lignes les plus importantes (ou contributives) peuvent ??tre mise en avant sur le graphique comme suit:

fviz_ca_row (m.ca, col.row = "contrib",
             gradient.cols = c ("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE,title="Graphe repr??sente la contribution des mots sur les 2 dim ")

#Le graphique donne une id??e de la contribution des lignes aux diff??rents p??les des dimensions. 
#Il est ??vident que les cat??gories suppress ,supprim et propos  ont une contribution importante
#au p??le positif de la premi??re dimension
#, tandis que les cat??gories arriv et jour ont une contribution majeure au p??le n??gatif de 
#la premi??re dimension

# Changez la transparence par les valeurs de contrib
fviz_ca_row (m.ca, alpha.row = "contrib",
             repel = TRUE)



################Qualit?? de repr??sentation des colonnes


# Colorer en fonction du cos2:
fviz_ca_col (m.ca, col.col = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE ,title="Graphe de Qualit?? de repr??sentation des colonnes " )

#Pour visualiser la contribution des colonnes aux deux dimensions
fviz_contrib (m.ca, choice = "col", axes = 1:2,title="Graphe repr??sente la contribution des colonne sur les 2 dim " )














