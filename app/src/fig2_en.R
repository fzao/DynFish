#
#  _______     _______   ____  _____
# |  __ \ \   / /  __ \ / __ \|  __ \
# | |  | \ \_/ /| |__) | |  | | |__) |
# | |  | |\   / |  ___/| |  | |  ___/
# | |__| | | |  | |    | |__| | |
# |_____/  |_|  |_|     \____/|_|
#
# Un outil d'aide au diagnostic de l'etat des populations de truite fario
#
# Copyright (c) EDF-IRSTEA 2018
#
# Auteurs : Fabrice Zaoui - Victor Bret
#
# Licence CeCILL v2.1
#
#
#########################################
### Fonction de creation de la FIGURE 2 : RELATION type 'SR' : densité d'une classe d'âge l'année y en fonction des densités de la classe d'âge précédente l'année y-1
#### Integration d'un niveau de densité 1+ ou Ad influençant la survie
#########################################
	# ids : nom de la station (utilisé pour le titre)
	# FS : Données chargée (correspondant au set de paramètres en entrée)
	# T10, T90, C : Valeur des paramètres d'entrées du modèle (caractéristiques de la station T10 annuelle, T90 annuelle et % de S de caches)
	# X1m, XAdm : Valeur de
	# [temp] OS : type d'OS (adapte les commandes d'ouverture de fenetres graphique

fig2_p0_en <- function(ids, FS, t_10, t_90, cache)
{
	par_name=paste('T10',t_10,'T90',t_90,'C',cache, sep="_")
	#par_name_full=paste('T10',t_10,'T90',t_90,'C',cache,'X1m',X1m,'XAdm',XAdm, sep="_")
	disc=length(FS[["X0"]])


	# Mise en forme donnees
	x0 <- FS[["X0"]]
	s0_025 <- FS[[par_name]][,'r1_025']
	s0_25 <- FS[[par_name]][,'r1_25']
	s0_50 <- FS[[par_name]][,'r1_50']
	s0_75 <- FS[[par_name]][,'r1_75']
	s0_975 <- FS[[par_name]][,'r1_975']

	x1 <- FS[["X1"]]

	# bad values and smoothing
	threshold <- 1.e-8
	s0_025[is.na(s0_025)] <- 0.
	s0_025[s0_025<threshold] <- 0.
	smoothing <- loess(s0_025 ~ x0)
	s0_025 <- smoothing$fitted
	s0_25[is.na(s0_25)] <- 0.
	s0_25[s0_25<threshold] <- 0.
	smoothing <- loess(s0_25 ~ x0)
	s0_25 <- smoothing$fitted
	s0_50[is.na(s0_50)] <- 0.
	s0_50[s0_50<threshold] <- 0.
	smoothing <- loess(s0_50 ~ x0)
	s0_50 <- smoothing$fitted
	s0_75[is.na(s0_75)] <- 0.
	s0_75[s0_75<threshold] <- 0.
	smoothing <- loess(s0_75 ~ x0)
	s0_75 <- smoothing$fitted
	s0_975[is.na(s0_975)] <- 0.
	s0_975[s0_975<threshold] <- 0.
	smoothing <- loess(s0_975 ~ x0)
	s0_975 <- smoothing$fitted

	dataF <- data.frame(x0, s0_025,s0_25,s0_50,s0_75,s0_975)

	## Subplots
	p0 <- plot_ly(dataF, x = ~x0, y = ~s0_975, type = 'scatter', mode = 'lines',
			line = list(color = 'black'),
			showlegend = FALSE, name = 'Percentile 97.5') %>%
	  add_trace(y = ~ s0_025, type = 'scatter', mode = 'lines',
				fill = 'tonexty', fillcolor='rgba(100,100,100,0.2)', line = list(color = 'black'),
				showlegend = FALSE, name = 'Percentile 2.5') %>%
	  add_trace(y = ~ s0_25, type = 'scatter', mode = 'lines',
				line = list(color='black'),
				showlegend = FALSE, name = 'Percentile 25') %>%
	  add_trace(y = ~ s0_75, type = 'scatter', mode = 'lines',
				fill = 'tonexty', fillcolor='rgba(50,50,50,0.2)', line = list(color = 'black'),
				showlegend = FALSE, name = 'Percentile 75') %>%
	  add_trace(y = ~ s0_50, type = 'scatter', mode = 'lines',
				line = list(color='red'),
				showlegend = FALSE, name = 'Median') %>%
	  layout(title = '1+ densities expected',
			 paper_bgcolor='rgb(255,255,255)', plot_bgcolor='rgb(239,239,239)',
			 xaxis = list(title = "0+ density year (n-1)",
						  gridcolor = 'rgb(255,255,255)',
						  showgrid = TRUE,
						  showline = FALSE,
						  showticklabels = TRUE,
						  tickcolor = 'rgb(127,127,127)',
						  ticks = 'outside',
						  zeroline = FALSE,
						  range=c(min(x0),max(x0))),
			 yaxis = list(title = "1+ density year (n)",
						  gridcolor = 'rgb(255,255,255)',
						  showgrid = TRUE,
						  showline = FALSE,
						  showticklabels = TRUE,
						  tickcolor = 'rgb(127,127,127)',
						  ticks = 'outside',
						  zeroline = FALSE,
						  range=c(min(x1),max(x1))))


	return(p0)
}


# type = "heatmap" or "surface"

fig2_hm_en <- function(ids, FS, t_10, t_90, cache, X1m, XAdm, type3D=FALSE)
{
	par_name=paste('T10',t_10,'T90',t_90,'C',cache, sep="_")
	#par_name_full=paste('T10',t_10,'T90',t_90,'C',cache,'X1m',X1m,'XAdm',XAdm, sep="_")
	disc=length(FS[["X0"]])



	# Mise en forme données
	x0 <- FS[["X0"]]
	s0_025 <- FS[[par_name]][,'r1_025']
	s0_25 <- FS[[par_name]][,'r1_25']
	s0_50 <- FS[[par_name]][,'r1_50']
	s0_75 <- FS[[par_name]][,'r1_75']
	s0_975 <- FS[[par_name]][,'r1_975']

	# bad values and smoothing
	threshold <- 1.e-8
	s0_025[is.na(s0_025)] <- 0.
	s0_025[s0_025<threshold] <- 0.
	smoothing <- loess(s0_025 ~ x0)
	s0_025 <- smoothing$fitted
	s0_25[is.na(s0_25)] <- 0.
	s0_25[s0_25<threshold] <- 0.
	smoothing <- loess(s0_25 ~ x0)
	s0_25 <- smoothing$fitted
	s0_50[is.na(s0_50)] <- 0.
	s0_50[s0_50<threshold] <- 0.
	smoothing <- loess(s0_50 ~ x0)
	s0_50 <- smoothing$fitted
	s0_75[is.na(s0_75)] <- 0.
	s0_75[s0_75<threshold] <- 0.
	smoothing <- loess(s0_75 ~ x0)
	s0_75 <- smoothing$fitted
	s0_975[is.na(s0_975)] <- 0.
	s0_975[s0_975<threshold] <- 0.
	smoothing <- loess(s0_975 ~ x0)
	s0_975 <- smoothing$fitted

	# loading FS_PopLvl
	if(Sys.info()["sysname"] == "Darwin"){
	  load(file=paste('../data/FS_PopLvl/FS_PopLvl_',par_name,'.RData',sep=''))
	}else{
	  load(file=paste('/home/dypop/data/FS_PopLvl/FS_PopLvl_',par_name,'.RData',sep=''))
	}

	x1 <- FS[["X1"]]
	s1_025 <- FS_PopLvl[[paste("XAdm_",XAdm,sep='')]][,'rAd_025']
	s1_25 <- FS_PopLvl[[paste("XAdm_",XAdm,sep='')]][,'rAd_25']
	s1_50 <- FS_PopLvl[[paste("XAdm_",XAdm,sep='')]][,'rAd_50']
	s1_75 <- FS_PopLvl[[paste("XAdm_",XAdm,sep='')]][,'rAd_75']
	s1_975 <- FS_PopLvl[[paste("XAdm_",XAdm,sep='')]][,'rAd_975']

	# bad values and smoothing
	threshold <- 1.e-8
	s1_025[is.na(s1_025)] <- 0.
	s1_025[s1_025<threshold] <- 0.
	smoothing <- loess(s1_025 ~ x1)
	s1_025 <- smoothing$fitted
	s1_25[is.na(s1_25)] <- 0.
	s1_25[s1_25<threshold] <- 0.
	smoothing <- loess(s1_25 ~ x1)
	s1_25 <- smoothing$fitted
	s1_50[is.na(s1_50)] <- 0.
	s1_50[s1_50<threshold] <- 0.
	smoothing <- loess(s1_50 ~ x1)
	s1_50 <- smoothing$fitted
	s1_75[is.na(s1_75)] <- 0.
	s1_75[s1_75<threshold] <- 0.
	smoothing <- loess(s1_75 ~ x1)
	s1_75 <- smoothing$fitted
	s1_975[is.na(s1_975)] <- 0.
	s1_975[s1_975<threshold] <- 0.
	smoothing <- loess(s1_975 ~ x1)
	s1_975 <- smoothing$fitted

	xAd <- FS[["XAd"]]
	sAd_025 <- FS_PopLvl[[paste("X1m_",X1m,sep='')]][,'rAd_025']
	sAd_25 <- FS_PopLvl[[paste("X1m_",X1m,sep='')]][,'rAd_25']
	sAd_50 <- FS_PopLvl[[paste("X1m_",X1m,sep='')]][,'rAd_50']
	sAd_75 <- FS_PopLvl[[paste("X1m_",X1m,sep='')]][,'rAd_75']
	sAd_975 <- FS_PopLvl[[paste("X1m_",X1m,sep='')]][,'rAd_975']

	# bad values and smoothing
	sAd_025[is.na(sAd_025)] <- 0.
	sAd_025[sAd_025<threshold] <- 0.
	smoothing <- loess(sAd_025 ~ xAd)
	sAd_025 <- smoothing$fitted
	sAd_25[is.na(sAd_25)] <- 0.
	sAd_25[sAd_25<threshold] <- 0.
	smoothing <- loess(sAd_25 ~ xAd)
	sAd_25 <- smoothing$fitted
	sAd_50[is.na(sAd_50)] <- 0.
	sAd_50[sAd_50<threshold] <- 0.
	smoothing <- loess(sAd_50 ~ xAd)
	sAd_50 <- smoothing$fitted
	sAd_75[is.na(sAd_75)] <- 0.
	sAd_75[sAd_75<threshold] <- 0.
	smoothing <- loess(sAd_75 ~ xAd)
	sAd_75 <- smoothing$fitted
	sAd_975[is.na(sAd_975)] <- 0.
	sAd_975[sAd_975<threshold] <- 0.
	smoothing <- loess(sAd_975 ~ xAd)
	sAd_975 <- smoothing$fitted


	dataF <- data.frame(x0, s0_025,s0_25,s0_50,s0_75,s0_975,
		x1, s1_025,s1_25,s1_50,s1_75,s1_975,
		xAd, sAd_025,sAd_25,sAd_50,sAd_75,sAd_975)

	# Values of heatmap
	mat_Zm=c(c(0,0), c(max(as.matrix(FS[[paste(par_name,'_2D',sep='')]])), max(as.matrix(FS[[paste(par_name,'_2D',sep='')]]))))
	dim(mat_Zm)=c(2,2)
	if(type3D==TRUE){
            type='surface'
        }else{
            type='heatmap'
        }
	HM <- plot_ly(z = as.matrix(FS[[paste(par_name,'_2D',sep='')]]),
			x = colnames(as.matrix(FS[[paste(par_name,'_2D',sep='')]])),
			y = rownames(as.matrix(FS[[paste(par_name,'_2D',sep='')]])),
			colorscale = list(c(0, "rgb(255, 0, 0)"), list(1, "rgb(0, 255, 0)")),
			cauto = F, cmin = 0, cmax = 40,
			type = type, colorbar=list(title='>+1 density\nyear(n)'))

	if(type3D==TRUE){
	  HM <- HM %>%
	    add_surface(z = ~mat_Zm,
	                x=c(XAdm,XAdm), y=c(0,max(FS[['X1']])), opacity = 0.7, colorscale = list(c(0,0),c("rgb(255,112,184)","rgb(255,112,184)")),showscale = FALSE)%>%
	    add_surface(z = ~t(mat_Zm),
	                y=c(X1m,X1m), x=c(0,max(FS[['XAd']])), opacity = 0.7, colorscale = list(c(0,0),c("rgb(255,112,184)","rgb(255,112,184)")), showscale = FALSE)%>%
	    layout(scene = list(
	      xaxis=list(title = ">1+ density\nyear (n-1)"),
	      yaxis=list(title = "1+ density\nyear (n-1)"),
	      zaxis=list(title = ">1+ density\nyear (n)")))
	  }

	if(type3D==FALSE){
	  HM <- HM %>%
	    add_segments(x = XAdm, xend = XAdm, y = -100, yend = 1000, line = list(color = 'red'))%>%
	    add_segments(x = -100, xend = 1000, y = X1m, yend = X1m, line = list(color = 'orange'))%>%
	    layout(title = ">1+ expected densities",
	           paper_bgcolor='rgb(255,255,255)', plot_bgcolor='rgb(239,239,239)',
	           #legend = list(orientation = 'h'),
	           legend = list(x = 0, y=-0.1),
	           xaxis = list(title = ">1+ density year (n-1)",
	                        gridcolor = 'rgb(255,255,255)',
	                        showgrid = TRUE,
	                        showline = FALSE,
	                        showticklabels = TRUE,
	                        tickcolor = 'rgb(127,127,127)',
	                        ticks = 'outside',
	                        zeroline = FALSE,
	                        range=c(min(FS[["XAd"]]),max(FS[["XAd"]]))),
	           yaxis = list(title = "1+ density\nyear (n-1)",
	                        gridcolor = 'rgb(255,255,255)',
	                        showgrid = TRUE,
	                        showline = FALSE,
	                        showticklabels = TRUE,
	                        tickcolor = 'rgb(127,127,127)',
	                        ticks = 'outside',
	                        zeroline = FALSE,
	                        range=c(min(FS[["X1"]]),max(FS[["X1"]]))),
	           showlegend = FALSE)
	  }



	# Marginal survival 1+ -> Ad (right margin : Rotated)
	p1 <- plot_ly(dataF, x = ~s1_975, y = ~x1, type = 'scatter', mode = 'lines',
			line = list(color = 'black'),
			showlegend = FALSE, name = 'Percentile 97.5') %>%
	  add_trace(x = ~ s1_025, type = 'scatter', mode = 'lines',
				fill = 'tonexty', fillcolor='rgba(100,100,100,0.2)', line = list(color = 'black'),
				showlegend = FALSE, name = 'Percentile 2.5') %>%
	  add_trace(x = ~ s1_25, type = 'scatter', mode = 'lines',
				line = list(color='black'),
				showlegend = FALSE, name = 'Percentile 25') %>%
	  add_trace(x = ~ s1_75, type = 'scatter', mode = 'lines',
				fill = 'tonexty', fillcolor='rgba(50,50,50,0.2)', line = list(color = 'black'),
				showlegend = FALSE, name = 'Percentile 75') %>%
	  add_trace(x = ~ s1_50, type = 'scatter', mode = 'lines',
				line = list(color='red'),
				showlegend = FALSE, name = 'Median')%>%
	  layout(showlegend = FALSE, plot_bordercolor='red', xaxis = list(title = paste(">1+ density year (n)")), xaxis = list(range=c(min(FS[["X1"]]),max(FS[["X1"]]))))


	pAd <- plot_ly(dataF, x = ~xAd, y = ~sAd_975, type = 'scatter', mode = 'lines',
			line = list(color = 'black'),
			showlegend = FALSE, name = 'Percentile 97.5') %>%
	  add_trace(y = ~ sAd_025, type = 'scatter', mode = 'lines',
				fill = 'tonexty', fillcolor='rgba(100,100,100,0.2)', line = list(color = 'black'),
				showlegend = FALSE, name = 'Percentile 2.5') %>%
	  add_trace(y = ~ sAd_25, type = 'scatter', mode = 'lines',
				line = list(color='black'),
				showlegend = FALSE, name = 'Percentile 25') %>%
	  add_trace(y = ~ sAd_75, type = 'scatter', mode = 'lines',
				fill = 'tonexty', fillcolor='rgba(50,50,50,0.2)', line = list(color = 'black'),
				showlegend = FALSE, name = 'Percentile 75') %>%
	  add_trace(y = ~ sAd_50, type = 'scatter', mode = 'lines',
				line = list(color='red'),
				showlegend = FALSE, name = 'Median')%>%
	  layout(showlegend = FALSE, plot_bordercolor='orange', yaxis = list(title = paste(">1+ density\nyear (n)")), yaxis = list(range=c(min(FS[["XAd"]]),max(FS[["XAd"]]))))


	# Heat map combined with marginal views
	HMcomb <- subplot(pAd, plotly_empty(), HM, p1, nrows = 2, shareX=TRUE, shareY=TRUE, heights = c(0.2, 0.8), widths = c(0.8,0.2))


	return(HMcomb)
	}
