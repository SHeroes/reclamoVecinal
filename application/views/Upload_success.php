<html>
 
   <head> 
      <title>Upload Form</title> 
   </head>
	
   <body>  
      <h3>Your file was successfully uploaded!</h3>  
		
      <ul> 
      <?php //print_r($upload_data);
         foreach( $upload_data as $item => $value){
           echo  '<li>'. $item. ': '.$value .'</li>';
         } 

      /*
         <?phpforeach ($upload_data as $item => $value):?> 
         <li><?php echo $item;?>: <?php echo $value;?></li> 
         <?phpendforeach; ?>
         */
         ?>
      </ul>  
		
      <p><?php echo anchor('upload', 'Upload Another File!'); ?></p>  
   </body>
	
</html>